class Image < ApplicationRecord
  has_one_attached :data

  belongs_to :campaign, optional: true

  after_create :set_image_job

  scope :update_campaign_id, -> (ids, campaign_id) {
    where(id: ids).update_all(campaign_id: campaign_id)
  }

  private

  def set_image_job
    DestroyOrphanImageJob.perform_in(30.minutes, id)
  end
end
