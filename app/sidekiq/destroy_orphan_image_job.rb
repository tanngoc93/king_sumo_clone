class DestroyOrphanImageJob
  include Sidekiq::Job

  sidekiq_options retry: false

  def perform(id)
    image = Image.find_by(id: id)
    return if image.nil? || image.campaign_id.present?
    image.destroy
  end
end
