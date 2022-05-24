# frozen_string_literal: true

class ProductsController < AuthenticatedController
  skip_before_action :authenticate_user!

  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    render(json: { products: @products })
  end
end
