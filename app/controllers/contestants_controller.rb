class ContestantsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ show new create ]
  before_action :set_campaign, only: %i[ index show new create destroy ]
  before_action :set_contestant, only: %i[ show ]
  before_action :check_cookies, only: %i[ new ]

  protect_from_forgery with: :null_session, only: %i[ create ]

  def index
    @contestants = @campaign.contestants.page(params[:page])
  end

  def show
    redirect_to contestant_register_path(@campaign.slug) unless @contestant
  end

  def new
    @contestant = @campaign.contestants.new
  end

  def create

    @contestant = @campaign.contestants.find_by(email: contestant_params[:email])

    respond_to do |format|
      if @contestant
        format.json {
          render json: {
            contestant: @contestant,
            redirect_to: contestant_registered_path(@campaign.slug, @contestant.secret_code)
          },
          status: :ok
        }
      else
        @contestant = @campaign.contestants.new(contestant_params)

        if @contestant.save
          format.json {
            render json: {
              contestant: @contestant,
              redirect_to: contestant_registered_path(@campaign.slug, @contestant.secret_code)
            },
            status: :created 
          }
        else
          format.json {
            render json: {
              message: @contestant.errors.full_messages.to_sentence
            },
            status: :unprocessable_entity
          }
        end
      end
    end
  end

  def destroy
    @contestant = @campaign.contestants.find_by(id: params[:id])

    respond_to do |format|
      if @contestant && @contestant.destroy
        format.html { redirect_back(fallback_location: root_path) }
      end
    end
  end

  private

  def set_campaign
    @campaign = Campaign.friendly.find(params[:campaign_id])
  end

  def set_contestant
    @contestant = @campaign.contestants.find_by(secret_code: params[:secret_code])
  end

  def set_cookies
    cookies[:campaign_id] = @contestant.campaign.slug
    cookies[:secret_code] = @contestant.secret_code
  end

  def unset_cookies
    cookies[:campaign_id] = nil
    cookies[:secret_code] = nil
  end

  def set_registered_ip
    request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip
  end

  def check_cookies
    campaign_id = cookies[:campaign_id]
    secret_code = cookies[:secret_code]

    if campaign_id && secret_code
      return unless campaign_id == params[:campaign_id]

      if @campaign.contestants.where(secret_code: secret_code).count > 0
        redirect_to contestant_registered_path(campaign_id, secret_code)
      end
    end
  end

  def contestant_params
    params.require(:contestant).permit(:full_name, :email)
  end
end
