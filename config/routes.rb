Rails.application.routes.draw do
  root 'users#index'
  get "home/doc"
  get "home/about"
  get 'map' => 'home#map'

  resources :users

  resources :apps do
    resources :comments
  end

  resources :sessions, only: [:create]

  delete '/logout' => "sessions#destroy"
  get 'desktop_login/:hash_key' => "sessions#desktop_login", as: 'desktop_login'

  mount API => '/'
end
