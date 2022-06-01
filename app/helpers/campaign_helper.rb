module CampaignHelper

  def status_badge(campaign)
    return "alert-info"    if campaign.upcoming?
    return "alert-success" if campaign.running?
    return "alert-danger"  if campaign.expired?
    return "alert-dark"    if campaign.archived?
  end
end
