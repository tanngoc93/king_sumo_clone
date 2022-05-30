class Image < ApplicationRecord
  has_one_attached :data

  belongs_to :campaign, optional: true

  after_create :set_image_job

  private

  def set_image_job
    DestroyOrphanImageJob.perform_in(30.minutes, id)
  end
end
