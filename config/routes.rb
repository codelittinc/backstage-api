# frozen_string_literal: true

Rails.application.routes.draw do
  resources :projects
  resources :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :customers
  get 'users/me'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
