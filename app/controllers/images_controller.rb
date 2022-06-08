class ImagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ create destroy ]

  def create
    image = Image.create(image_params)

    render json: {
      image_preview: render_to_string(
        locals: {
          image: image
        },
        partial: "campaigns/image_preview",
        formats: :html,
        layout: false
      )
    }
  end

  def destroy
    image = Image.find_by(id: params[:id])

    image.destroy if image.present?
      
    head :no_content
  end

  private

  def image_params
    params.permit(:data)
  end
end
