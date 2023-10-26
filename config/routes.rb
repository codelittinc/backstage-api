# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Sidekiq::Web => '/sidekiq'

  resources :projects do
    resources :statement_of_works
  end
  resources :users
  resources :customers
  resources :professions, only: [:index]
  resources :skills, only: [:index]
  resources :issues, only: [:index]
  resources :permissions, only: [:index]
end
