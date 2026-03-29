# frozen_string_literal: true

# mount sidekiq
require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  mount Sidekiq::Web, at: "/sidekiq"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  resources :standups, path: "s"

  devise_for :users, controllers: { registrations: "registrations" }
  resource :accounts

  get "user/me", to: "users#me", as: "my_settings"
  patch "user/update_me", to: "users#update_me", as: "update_my_settings"
  get "user/password", to: "users#password", as: "my_password"
  patch "user/update_password", to: "users#update_password", as: "my_update_password"

  get "t/new", to: "teams#new"
  get "t/:id/edit", to: "teams#edit"
  get "t/:id/s", to: "teams/standups#index", as: "team_standups"
  get "t/:id/s/(:date)", to: "teams/standups#index", as: "team_standups_by_date"
  get "t/:id/(:date)", to: "teams#show"
  resources :teams, path: "t"

  scope "account", as: "account" do
    resources :products, only: [:index], controller: "accounts/products"

    resources :users do
      member do
        get "s", to: "users/standups#index", as: "standups"
      end
    end
  end

  get "dates/:date", to: "dates#update", as: "update_date"

  get "activity/mine"
  get "activity/feed"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "activity#mine"
end
