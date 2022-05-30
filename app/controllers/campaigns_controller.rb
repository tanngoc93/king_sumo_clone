class CampaignsController < ApplicationController
  before_action :set_time_zones, only: %i[ new edit ]
  before_action :set_campaign, only: %i[ show edit update destroy ]

  def index
    @campaigns = current_user ? current_user.campaigns.page(params[:page]) : []
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
      Image.update_campaign_id(image_ids.map(&:to_i), @campaign.id) if image_ids.any?
      redirect_to campaigns_path, notice: "Campaign was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @campaign && @campaign.update(campaign_params)

      image_ids = params[:prize_images]
      Image.update_campaign_id(image_ids.map(&:to_i), @campaign.id) if image_ids.any?
      redirect_to campaigns_path, notice: "Campaign was successfully updated."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @campaign && @campaign.destroy
      redirect_to campaigns_path, notice: "Campaign was successfully deleted."
    else
      redirect_to campaigns_path, notice: "Something went wrong..."
    end
  end

  private

  def set_campaign
    @campaign = current_user.campaigns.friendly.find(params[:id])
  rescue
    redirect_to root_path, notice: "Something went wrong..."
  end

  def set_time_zones
    data = File.join(Rails.root, "lib", "time_zones", "data.json")

    File.open(data) do |t|
      @time_zones = JSON.parse(t.read)
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
      ]
    )
  end
end
