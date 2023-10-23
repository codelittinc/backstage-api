# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  resources :projects
  resources :users
  resources :customers
  resources :professions, only: [:index]
  resources :skills, only: [:index]
  resources :issues, only: [:index]
end
