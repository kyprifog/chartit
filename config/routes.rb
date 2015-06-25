Rails.application.routes.draw do
  devise_for :users
  mount API::Base => '/api'
  root :to => 'charts#index'
  
  resources :charts, only: [:index, :new, :edit, :update, :create, :show, :destroy]
end
