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
      apps = App.top_listed.limit(params[:limit])
      wrapper(apps)
    end

    desc "lookup_app api"
    params do
      requires :app_ids
    end
    get "lookup_app" do
      app = App.lookup_app(params[:app_ids])
      wrapper(app)
    end
  end
end