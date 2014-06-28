Rails.application.routes.draw do
  root 'home#index'

  get "home/doc"
  mount API => '/'
end
