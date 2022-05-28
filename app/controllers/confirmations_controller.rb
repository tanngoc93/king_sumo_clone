class ConfirmationsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ edit ]
  before_action :set_contestant, only: %i[ edit ]

  def edit   
    unless @contestant.confirmed?
      @contestant.update(confirmed: true, confirmed_at: DateTime.now, confirmed_ip: confirmed_ip)
    end

    redirect_to contestant_registered_path(@contestant.campaign.slug, @contestant.secret_code)
  end

  private

  def set_contestant
    @contestant = Contestant.find_by(confirmation_token: params[:confirmation_token])
  rescue
    redirect_to root_path, notice: "Something went wrong..."
  end

  def confirmed_ip
    request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip
  end
end
