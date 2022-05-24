# frozen_string_literal: true

class HomeShopifyController < ApplicationController
  skip_before_action :authenticate_user!

  include ShopifyApp::EmbeddedApp
  include ShopifyApp::RequireKnownShop
  include ShopifyApp::ShopAccessScopesVerification

  def index
    @shop_origin = current_shopify_domain

    if secure_request?( shopify_params ) && user = User.find_by(shopify_domain: @shop_origin)
      if sign_in(user)
        redirect_to campaigns_path
      end
    end
  end

  private
    def secure_request?(parameters)
      Rack::Utils.secure_compare(parameters["hmac"], calculate_hmac(parameters)) # true or false
    end

    def calculate_hmac(parameters)
      OpenSSL::HMAC.hexdigest("sha256", ShopifyApp.configuration.secret, sorted_string_params(parameters))
    end

    def sorted_string_params(parameters)
      parameters.except(:hmac).to_query
    end

    def shopify_params
      params.permit(
        :hmac,
        :host,
        :session,
        :shop,
        :timestamp,
        :local
      )
    end
end
