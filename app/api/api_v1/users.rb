class Users < Grape::API
  helpers SharedParams

  resources :users do
    desc "get user info"
    params do
      use :auth
      requires :user_id
    end
    get "/:user_id" do
      authenticate!

      user = User.find(params[:user_id])

      if user
        wrapper(user)
      else
        wrapper(false)
      end
    end

    ######

    desc "user's friends"
    params do
      use :auth
    end
    get ':user_id/friends' do

    end

    ######

    desc "upload apps"
    params do
      use :auth
    end
    post "apps" do
      authenticate!
      status(200)
    end
  end

  #####
  desc "user's apps"
  params do
    use :auth
    requires :user_id
  end
  get ":user_id/apps" do
    authenticate!
    user = User.find(params[:user_id])

    if user
      apps = user.apps
      wrapper(apps)
    else
      wrapper(false)
    end
  end
end