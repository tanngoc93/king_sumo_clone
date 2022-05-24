class ImagesController < ApplicationController

  def destroy
    prize_image = ActiveStorage::Attachment.find(params[:id])
    
    respond_to do |format|
      if prize_image.purge
        format.js   {}
        format.json {}
      end
    end
  end
end
