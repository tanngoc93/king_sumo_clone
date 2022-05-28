class ImagesController < ApplicationController
  protect_from_forgery with: :null_session, only: [:create]

  def create
    image = Image.create(image_params)

    render json: {
      image_file_html: render_to_string(
        locals: { id: image.id, url: url_for(image.data) },
        partial: "campaigns/image_file", 
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
