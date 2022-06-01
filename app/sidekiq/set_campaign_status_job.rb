class SetCampaignStatusJob
  include Sidekiq::Job

  def perform(id, *args)

    campaign = Campaign.find_by(id: id)

    return unless campaign.present?

    set_campaign_status(campaign)
  end

  private

  def set_campaign_status(campaign)

    now = Time.now.in_time_zone(campaign.time_zone)

    if now.between?( campaign.starts_at, campaign.ends_at )
      campaign.update(status: :running)
    else
      campaign.update(status: :expired)
    end
  end
end
