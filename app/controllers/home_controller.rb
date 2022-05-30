class HomeController < ApplicationController
  # skip_before_action :authenticate_user!, only: %i[ index ]

  def index
    redirect_to campaigns_path if current_user
  end
end
