Rails.application.routes.draw do
  root 'home#index'
  get "home/doc"
  resources :users
  resources :apps
  resources :sessions, only: [:create] do
    collection do
      get 'qrlogin'
    end
  end
  get 'desktop_login/:hash_key' => "sessions#desktop_login", as: 'desktop_login'

  mount API => '/'
end
