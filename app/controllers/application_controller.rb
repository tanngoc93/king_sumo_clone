class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_host
  before_action :authenticate_user!
  before_action :set_referral_cookie

  protected
    def set_referral_cookie
      if params[:ref]
        cookies[:referral_code] = {
          value: params[:ref],
          expires: 30.days.from_now,
        }
      end
    end

    def set_host
      @host = params[:host]
    end
end
