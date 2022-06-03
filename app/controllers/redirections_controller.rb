class RedirectionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ new ]
  before_action :set_contestant, only: %i[ new ]

  def new
    endpoint = root_url

    campaign = @contestant.campaign

    campaign_url = "#{ endpoint.chomp('/') + contestant_register_path(campaign, { ref: @contestant.referral_code }) }"

    if ShareAction.names.key?( params[:event] )

      ShareActionManagement.find_or_create_by(contestant: @contestant, share_action: ShareAction.find_by(name: params[:event]))

      case params[:event]
      when "email"
        endpoint = "mailto:somebody@somewhere.com/?subject=#{ campaign.title }&body=#{ campaign.title } #Giveaway<br /><br />#{ campaign_url }<br /><br />Referral Code : #{ @contestant.referral_code }"
      when "messenger"
        endpoint = "https://messenger.com/"
      when "facebook"
        endpoint = "https://www.facebook.com/sharer/sharer.php?u=#{ campaign_url }&title=#{ campaign.title }&description=#{ campaign.description }"
      when "pinterest"
        endpoint = "http://pinterest.com/pin/create/button/?url=#{ campaign_url }&description=#{ campaign.title }"
      when "twitter"
        endpoint = "https://twitter.com/share?url=#{ campaign_url }&via=MyCakeGiveaway&hashtags=Giveaway&text=#{ campaign.title }"
      end

    elsif BonusEntry.names.key?(params[:event])

      bonus_entry = BonusEntry.find_by(name: params[:event])

      BonusEntryManagement.find_or_create_by(contestant: @contestant, bonus_entry: bonus_entry)

      endpoint = bonus_entry.action_url

    else
      endpoint = contestant_register_path(campaign)
    end

    redirect_to endpoint, allow_other_host: true
  end

  private

  def set_contestant
    @contestant = Contestant.find_by(secret_code: params[:secret_code])
  end
end
