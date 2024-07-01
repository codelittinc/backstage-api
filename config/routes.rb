# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  resources :dynamic_datasets
  resources :time_offs, only: [:create]
  post 'time_off/destroy', to: 'time_offs#destroy'
  resources :time_entries
  resources :payments
  resources :assignments
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  if Rails.env.production?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      # Set the username and password
      # It's highly recommended to use environment variables for security reasons
      username == ENV['SIDEKIQ_PORTAL_USERNAME'] && password == ENV['SIDEKIQ_PORTAL_PASSWORD']
    end
  end

  mount Sidekiq::Web => '/sidekiq'

  resources :requirements
  resources :projects

  resources :statement_of_works

  namespace :analytics do
    resources :time_entries, only: [:index]
    resources :finances, only: [:index]
    resources :project_progress, only: [:index]
  end

  resources :users
  resources :customers
  resources :professions, only: [:index]
  resources :skills, only: [:index]
  resources :issues, only: [:index]
  resources :permissions, only: [:index]
end
