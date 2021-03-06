class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :authenticate_user!, :set_referral_cookie, :set_host

  protected

  def set_referral_cookie
    if params[:ref]
      cookies[:referral_code] = {
        value: params[:ref],
        expires: 30.days.from_now
      }
    end
  end

  def set_host
    @host = params[:host]
  end
end
