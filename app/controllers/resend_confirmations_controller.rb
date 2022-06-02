class ResendConfirmationsController < ApplicationController
  # skip_before_action :authenticate_user!, only: %i[ edit ]
  before_action :set_contestant, only: %i[ create ]

  def create
    if @contestant && @contestant.resend_confirmation_email
      redirect_to campaign_contestants_path(@contestant.campaign), notice: "Confirmation email has been resent!"
    else
      redirect_to campaigns_path, alert: "Something went wrong..."
    end
  end

  private

  def set_contestant
    @contestant = Contestant.find_by(secret_code: params[:secret_code])
  end
end
