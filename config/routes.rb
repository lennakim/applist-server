Rails.application.routes.draw do


  root 'home#index'

  resources :users
  resources :apps

  get "home/doc"
  mount API => '/'
end
