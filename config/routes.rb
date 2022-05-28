require "sidekiq/web"

Rails.application.routes.draw do
  devise_for :users

  resources :campaigns do
    resources :contestants, only: [:index, :destroy]
  end

  resources :images, only: [:create, :destroy]

  get  "/campaign/:campaign_id/:secret_code", to: "contestants#show",  as: :contestant_registered
  get  "/campaign/:campaign_id",              to: "contestants#new"
  post "/campaign/:campaign_id",              to: "contestants#create", as: :contestant_register

  get  "/confirmation/:confirmation_token",   to: "confirmations#edit", as: :contestant_confirmation

  get  "/:secret_code",                       to: "redirections#new",   as: :redirection

  root "home#index"

  mount Sidekiq::Web => "/sidekiq"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
