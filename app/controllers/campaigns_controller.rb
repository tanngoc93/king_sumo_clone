class CampaignsController < ApplicationController
  before_action :set_timezones, only: %i[ new edit ]
  before_action :set_campaign, only: %i[ show edit update destroy ]

  def index
    @campaigns= 
      if current_user
        current_user.campaigns.page(params[:page])
      else
        []
      end
  end

  def show
    respond_to do |format|
      format.html
      format.csv { send_data @campaign.to_csv, filename: "campaign-#{Date.today}.csv" }
    end
  end

  def new
    @campaign = Campaign.new

    ShareAction.names.keys.each do |name|
      @campaign.share_actions.build(name: name)
    end
  end

  def create
    @campaign = Campaign.new(campaign_params.merge(user: current_user))

    if @campaign.save
      image_ids = params[:prize_images]

      unless image_ids.empty?
        Image.where(id: image_iunds.map(&:to_i)).update_all(campaign_id: @campaign.id)
      end

      redirect_to campaigns_path, notice: "Campaign was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @campaign && @campaign.update(campaign_params.except(:prize_images))
      if campaign_params[:prize_images].present?
        @campaign.prize_images.attach(campaign_params[:prize_images])
      end

      redirect_to campaigns_path, notice: "Campaign was successfully updated."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @campaign && @campaign.destroy
      redirect_to campaigns_path, notice: "Campaign was successfully deleted."
    end
  end

  private
    def set_campaign
      @campaign = current_user.campaigns.friendly.find(params[:id])
    rescue
      redirect_to root_path
    end

    def set_timezones
      file = File.join(Rails.root, "lib", "timezones", "timezones.json")

      File.open(file) do |f|
        @timezones = JSON.parse(f.read)
      end
    end

    def campaign_params
      params.require(:campaign).permit(
        :title,
        :description,
        :starts_at,
        :ends_at,
        :awarded_at,
        :timezone,
        :gdpr,
        :offered_by_name,
        :offered_by_url,
        :number_of_winners,
        :winner_prize_name,
        :winner_prize_value,
        :number_of_runners_up,
        :runner_up_prize_name,
        :runner_up_prize_value,
        bonus_entries_attributes: [
          :id,
          :name,
          :action_points,
          :action_text,
          :action_url,
          :_destroy
        ],
        share_actions_attributes: [
          :id,
          :name,
          :action_points,
          :checked
        ],
        prize_images: []
      )
    end
end
