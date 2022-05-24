require 'sidekiq/web'

Rails.application.routes.draw do
  get '/products', :to => 'products#index'
  # 
  mount Sidekiq::Web => "/sidekiq"
  # 
  get "/shopifapp", to: "home_shopify#index"
  # 
  get "/splash_page/index", to: "splash_page#index"
  # 
  mount ShopifyApp::Engine, at: "/shopifapp"
  # 
  devise_for :users
  #
  resources :campaigns do
    resources :contestants, only: [:index, :destroy]
  end
  # 
  resources :images, only: [:destroy]
  # 
  get  "/campaign/:campaign_id/:secret_code", to: "contestants#show",  as: :contestant_registered
  get  "/campaign/:campaign_id",              to: "contestants#new"
  post "/campaign/:campaign_id",              to: "contestants#create", as: :contestant_register
  #
  get  "/confirmation/:confirmation_token",   to: "confirmations#edit", as: :contestant_confirmation
  #
  get  "/redirection/:secret_code",           to: "redirections#new",   as: :redirection
  # 
  root "home#index"
  # 
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

# https://infinite-caverns-47866.herokuapp.com/shopifapp/auth/shopify/callback