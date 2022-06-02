class ContestantsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ show new create ]
  before_action :set_campaign, only: %i[ index show new create destroy ]
  before_action :set_contestant, only: %i[ show ]
  before_action :set_contestant_from_cookies, only: %i[ new ]

  def index
    @contestants = @campaign.contestants.page(params[:page])
  end

  def show
    redirect_to contestant_register_path(@campaign.slug) unless @contestant
  end

  def new
    if @contestant
      redirect_to contestant_registered_path( @contestant.campaign.slug, @contestant.secret_code )
    else
      @contestant = @campaign.contestants.new
    end
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
  rescue
    redirect_to root_url
  end

  def set_contestant
    @contestant = @campaign.contestants.find_by(secret_code: params[:secret_code])
  end

  def set_contestant_from_cookies
    @contestant = Contestant.find_by(secret_code: cookies[:contestant_secret_code])
  end

  def contestant_params
    params.require(:contestant).permit(:full_name, :email)
  end
end
