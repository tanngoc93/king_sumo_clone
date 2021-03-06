require "sidekiq/web"

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  mount Sidekiq::Web => "/sidekiq"

  devise_for :users

  resources :images, only: [:create, :destroy]

  resources :campaigns do
    resources :contestants, only: [:index, :destroy]
  end

  get  "/campaign/:campaign_id/:secret_code", to: "contestants#show",  as: :contestant_registered
  get  "/campaign/:campaign_id",              to: "contestants#new"
  post "/campaign/:campaign_id",              to: "contestants#create", as: :contestant_register

  post "/resend_confirmation/:secret_code",   to: "resend_confirmations#create", as: :contestant_resend_confirmation
  get  "/confirmation/:confirmation_token",   to: "confirmations#edit", as: :contestant_confirmation

  get  "/:secret_code",                       to: "redirections#new",   as: :redirection

  root "home#index"
end
