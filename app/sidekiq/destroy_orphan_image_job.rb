class DestroyOrphanImageJob
  include Sidekiq::Job

  sidekiq_options retry: false

  def perform(id, *args)
    image = Image.find_by(id: id)
    return if image && image.campaign_id.present?
    image.destroy
  end
end
