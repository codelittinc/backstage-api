# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  resources :projects
  resources :users
  resources :customers
  resources :professions, only: [:index]
end
