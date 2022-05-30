class Image < ApplicationRecord
  has_one_attached :data
  belongs_to :campaign, optional: true

  after_create :set_image_job

  private

  def set_image_job
    ImageJob.perform_in(30.minutes, id)
  end
end
