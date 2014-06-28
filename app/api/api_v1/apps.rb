class Apps < Grape::API
  helpers SharedParams

  resources :apps do
    desc "app list"
    get 'list' do
      apps = App.recent
      wrapper(apps)
    end

    desc "top app list"
    params do
      optional :limit, type: Integer, default: 1, desc: 'Limit Default value is 100'
    end
    get "top_list" do
      apps = App.top_listed(limit=100)
      wrapper(apps)
    end
  end
end