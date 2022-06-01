class CampaignsController < ApplicationController
  before_action :set_time_zones, only: %i[ new edit ]
  before_action :set_campaign, only: %i[ show edit update destroy ]

  MAPPING = { "International Date Line West" => "Etc/GMT+12", "Midway Island" => "Pacific/Midway", "American Samoa" => "Pacific/Pago_Pago", "Hawaii" => "Pacific/Honolulu", "Alaska" => "America/Juneau", "Pacific Time (US & Canada)" => "America/Los_Angeles", "Tijuana" => "America/Tijuana", "Mountain Time (US & Canada)" => "America/Denver", "Arizona" => "America/Phoenix", "Chihuahua" => "America/Chihuahua", "Mazatlan" => "America/Mazatlan", "Central Time (US & Canada)" => "America/Chicago", "Saskatchewan" => "America/Regina", "Guadalajara" => "America/Mexico_City", "Mexico City" => "America/Mexico_City", "Monterrey" => "America/Monterrey", "Central America" => "America/Guatemala", "Eastern Time (US & Canada)" => "America/New_York", "Indiana (East)" => "America/Indiana/Indianapolis", "Bogota" => "America/Bogota", "Lima" => "America/Lima", "Quito" => "America/Lima", "Atlantic Time (Canada)" => "America/Halifax", "Caracas" => "America/Caracas", "La Paz" => "America/La_Paz", "Santiago" => "America/Santiago", "Newfoundland" => "America/St_Johns", "Brasilia" => "America/Sao_Paulo", "Buenos Aires" => "America/Argentina/Buenos_Aires", "Montevideo" => "America/Montevideo", "Georgetown" => "America/Guyana", "Puerto Rico" => "America/Puerto_Rico", "Greenland" => "America/Godthab", "Mid-Atlantic" => "Atlantic/South_Georgia", "Azores" => "Atlantic/Azores", "Cape Verde Is." => "Atlantic/Cape_Verde", "Dublin" => "Europe/Dublin", "Edinburgh" => "Europe/London", "Lisbon" => "Europe/Lisbon", "London" => "Europe/London", "Casablanca" => "Africa/Casablanca", "Monrovia" => "Africa/Monrovia", "UTC" => "Etc/UTC", "Belgrade" => "Europe/Belgrade", "Bratislava" => "Europe/Bratislava", "Budapest" => "Europe/Budapest", "Ljubljana" => "Europe/Ljubljana", "Prague" => "Europe/Prague", "Sarajevo" => "Europe/Sarajevo", "Skopje" => "Europe/Skopje", "Warsaw" => "Europe/Warsaw", "Zagreb" => "Europe/Zagreb", "Brussels" => "Europe/Brussels", "Copenhagen" => "Europe/Copenhagen", "Madrid" => "Europe/Madrid", "Paris" => "Europe/Paris", "Amsterdam" => "Europe/Amsterdam", "Berlin" => "Europe/Berlin", "Bern" => "Europe/Zurich", "Zurich" => "Europe/Zurich", "Rome" => "Europe/Rome", "Stockholm" => "Europe/Stockholm", "Vienna" => "Europe/Vienna", "West Central Africa" => "Africa/Algiers", "Bucharest" => "Europe/Bucharest", "Cairo" => "Africa/Cairo", "Helsinki" => "Europe/Helsinki", "Kyiv" => "Europe/Kiev", "Riga" => "Europe/Riga", "Sofia" => "Europe/Sofia", "Tallinn" => "Europe/Tallinn", "Vilnius" => "Europe/Vilnius", "Athens" => "Europe/Athens", "Istanbul" => "Europe/Istanbul", "Minsk" => "Europe/Minsk", "Jerusalem" => "Asia/Jerusalem", "Harare" => "Africa/Harare", "Pretoria" => "Africa/Johannesburg", "Kaliningrad" => "Europe/Kaliningrad", "Moscow" => "Europe/Moscow", "St. Petersburg" => "Europe/Moscow", "Volgograd" => "Europe/Volgograd", "Samara" => "Europe/Samara", "Kuwait" => "Asia/Kuwait", "Riyadh" => "Asia/Riyadh", "Nairobi" => "Africa/Nairobi", "Baghdad" => "Asia/Baghdad", "Tehran" => "Asia/Tehran", "Abu Dhabi" => "Asia/Muscat", "Muscat" => "Asia/Muscat", "Baku" => "Asia/Baku", "Tbilisi" => "Asia/Tbilisi", "Yerevan" => "Asia/Yerevan", "Kabul" => "Asia/Kabul", "Ekaterinburg" => "Asia/Yekaterinburg", "Islamabad" => "Asia/Karachi", "Karachi" => "Asia/Karachi", "Tashkent" => "Asia/Tashkent", "Chennai" => "Asia/Kolkata", "Kolkata" => "Asia/Kolkata", "Mumbai" => "Asia/Kolkata", "New Delhi" => "Asia/Kolkata", "Kathmandu" => "Asia/Kathmandu", "Astana" => "Asia/Dhaka", "Dhaka" => "Asia/Dhaka", "Sri Jayawardenepura" => "Asia/Colombo", "Almaty" => "Asia/Almaty", "Novosibirsk" => "Asia/Novosibirsk", "Rangoon" => "Asia/Rangoon", "Bangkok" => "Asia/Bangkok", "Hanoi" => "Asia/Bangkok", "Jakarta" => "Asia/Jakarta", "Krasnoyarsk" => "Asia/Krasnoyarsk", "Beijing" => "Asia/Shanghai", "Chongqing" => "Asia/Chongqing", "Hong Kong" => "Asia/Hong_Kong", "Urumqi" => "Asia/Urumqi", "Kuala Lumpur" => "Asia/Kuala_Lumpur", "Singapore" => "Asia/Singapore", "Taipei" => "Asia/Taipei", "Perth" => "Australia/Perth", "Irkutsk" => "Asia/Irkutsk", "Ulaanbaatar" => "Asia/Ulaanbaatar", "Seoul" => "Asia/Seoul", "Osaka" => "Asia/Tokyo", "Sapporo" => "Asia/Tokyo", "Tokyo" => "Asia/Tokyo", "Yakutsk" => "Asia/Yakutsk", "Darwin" => "Australia/Darwin", "Adelaide" => "Australia/Adelaide", "Canberra" => "Australia/Melbourne", "Melbourne" => "Australia/Melbourne", "Sydney" => "Australia/Sydney", "Brisbane" => "Australia/Brisbane", "Hobart" => "Australia/Hobart", "Vladivostok" => "Asia/Vladivostok", "Guam" => "Pacific/Guam", "Port Moresby" => "Pacific/Port_Moresby", "Magadan" => "Asia/Magadan", "Srednekolymsk" => "Asia/Srednekolymsk", "Solomon Is." => "Pacific/Guadalcanal", "New Caledonia" => "Pacific/Noumea", "Fiji" => "Pacific/Fiji", "Kamchatka" => "Asia/Kamchatka", "Marshall Is." => "Pacific/Majuro", "Auckland" => "Pacific/Auckland", "Wellington" => "Pacific/Auckland", "Nuku'alofa" => "Pacific/Tongatapu", "Tokelau Is." => "Pacific/Fakaofo", "Chatham Is." => "Pacific/Chatham", "Samoa" => "Pacific/Apia" }

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
      Image.update_campaign_id(image_ids.map(&:to_i), @campaign.id) if image_ids && image_ids.any?
      redirect_to campaigns_path, notice: "Campaign was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @campaign && @campaign.update(campaign_params)

      image_ids = params[:prize_images]
      Image.update_campaign_id(image_ids.map(&:to_i), @campaign.id) if image_ids && image_ids.any?
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
    @time_zones = MAPPING.map { |zone| [zone[0], zone[1]] }.sort
  end

  def campaign_params
    params.require(:campaign).permit(
      :title,
      :description,
      :starts_at,
      :ends_at,
      :awarded_at,
      :time_zone,
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
