# frozen_string_literal: true
class Shop < ActiveRecord::Base
  include ShopifyApp::ShopSessionStorageWithScopes

  after_create :create_shop_user

  before_destroy :destroy_shop_user

  def uninstall
    destroy
  end

  def uninstall!
    destroy!
  end

  def api_version
    ShopifyApp.configuration.api_version
  end

  private
    def create_shop_user
      ShopifyAPI::Session.temp(domain: self.shopify_domain, token: self.shopify_token, api_version: self.api_version) do
        shop = ShopifyAPI::Shop.current
        password = generate_password
        user = User.new(
          email: "#{SecureRandom.urlsafe_base64(3)}-#{shop.email}",
          password: password,
          password_confirmation: password,
          shopify_domain: self.shopify_domain,
          user_type: :shopify
        )
        user.skip_confirmation!
        user.save!
      end
    end

    def destroy_shop_user
      User.find_by(shopify_domain: self.shopify_domain).destroy
    end

    def generate_password
      SecureRandom.hex(10)
    end
end
