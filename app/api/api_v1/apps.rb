class Apps < Grape::API
  helpers SharedParams

  resources :apps do
    get 'list' do
      apps = App.recent
      wrapper(apps)
    end
  end
end