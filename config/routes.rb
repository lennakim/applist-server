Rails.application.routes.draw do

  root 'home#index'

  resources :users

  get "home/doc"
  mount API => '/'
end
