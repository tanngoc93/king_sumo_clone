class SplashPageController < ApplicationController
  skip_before_action :authenticate_user!

  include ShopifyApp::EmbeddedApp
  include ShopifyApp::RequireKnownShop
  include ShopifyApp::ShopAccessScopesVerification
end
