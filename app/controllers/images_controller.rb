class ImagesController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    image = Image.create!(image_params)

    render json: {
      upload_preview: render_to_string(
        locals: {
          image: image
        },
        partial: "campaigns/upload_preview", 
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
