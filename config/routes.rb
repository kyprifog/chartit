Rails.application.routes.draw do
  devise_for :users
  mount API::Base => '/api'
  root :to => 'charts#index'
end
