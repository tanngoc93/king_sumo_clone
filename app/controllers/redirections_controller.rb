class RedirectionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ new ]
  before_action :set_contestant, only: %i[ new ]

  def new

    campaign = @contestant.campaign

    if ShareAction.names.key?( params[:event] )

      ShareActionManagement.find_or_create_by(contestant: @contestant, share_action: ShareAction.find_by(name: params[:event]))

      case params[:event].to_sym
      when :email
        redirect_to "mailto:somebody@somewhere.com/?subject=#{ campaign.title }&body=#{ campaign.title } #giveaway #enter #win<br /><br /><a href='#{ request.base_url + contestant_register_path(campaign, { ref: @contestant.referral_code }) }'>#{ request.base_url + contestant_register_path(campaign, { ref: @contestant.referral_code }) }</a>"
      when :facebook
        redirect_to "https://www.facebook.com/sharer/sharer.php?u=#{ request.base_url + contestant_register_path(campaign, { ref: @contestant.referral_code }) }&title=#{ campaign.title }&description=#{ campaign.description }"
      when :pinterest
        redirect_to "http://pinterest.com/pin/create/button/?url=#{ request.base_url + contestant_register_path(campaign, { ref: @contestant.referral_code }) }&description=#{ campaign.title }"
      when :twitter
        redirect_to "https://twitter.com/share?url=#{ request.base_url + contestant_register_path(campaign, { ref: @contestant.referral_code }) }&via=GemkhinGiveaway&hashtags=giveaway,win&text=#{ campaign.title }"
      else
        redirect_to "mailto:somebody@omewhere.com/?subject=#{ campaign.title }&body=#{ campaign.title } #giveaway #enter #win<br /><br /><a href='#{ request.base_url + contestant_register_path(campaign, { ref: @contestant.referral_code }) }'>#{ request.base_url + contestant_register_path(campaign, { ref: @contestant.referral_code }) }</a>"
      end

    elsif BonusEntry.names.key?(params[:event])
      bonus_entry = BonusEntry.find_by(name: params[:event])
      BonusEntryManagement.find_or_create_by(contestant: @contestant, bonus_entry: bonus_entry)
      redirect_to bonus_entry.action_url
    else
      redirect_to contestant_register_path(campaign)
    end
  end

  private

  def set_contestant
    @contestant = Contestant.find_by(secret_code: params[:secret_code])
  rescue
    redirect_to root_path, notice: "Something went wrong..."
  end
end
