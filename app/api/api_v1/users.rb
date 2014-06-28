class Users < Grape::API
  helpers SharedParams
  helpers WeiboHelper

  resources :users do
    #####
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

    #####

    desc "user's friends"
    params do
      use :auth
      requires :user_id
    end
    get ':user_id/friends' do
      authenticate!

      user = User.find(params[:user_id])

      if user
        weibo_account = user.weibo_account

        friends = if weibo_account.friends
          weibo_account.friends
        else
          result = weibo_friends(weibo_account.uid, weibo_account.token)
          weibo_account.friends = result['users'].map{|u| u['id']}
          weibo_account.save
          weibo_account.friends
        end

        a = Authentication.where(:uid.in => friends)

        if a
          users = a.map(&:user)
          hash = {}
          hash[:friends] = users

          wrapper(hash)
        else
          wrapper(false)
        end
      else
        wrapper(false)
      end
    end

    ######

    desc "upload top apps "
    params do
      use :auth
      requires :app_ids
    end
    post "top_apps" do
      authenticate!

      app_ids = params[:app_ids].split(',')
      top_apps = []

      app_ids.each do |app_id|
        top_apps << App.create(appid: app_id)
      end

      current_user.save_top_list(top_apps)

      status(200)

      wrapper(true)
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

    #####
    desc "upload user apps"
    params do
      use :auth
      requires :app_ids
    end
    post "apps" do
      authenticate!

      app_ids = params[:app_ids].split(',')
      apps = []

      app_ids.each do |app_id|
        apps << App.create(appid: app_id)
      end

      current_user.save_apps(apps)
      status(200)
      wrapper(true)
    end

    desc "user's top apps"
    params do
      use :auth
      requires :user_id
    end
    get ':user_id/top_apps' do
      authenticate!

      user = User.find(params[:user_id])

      if user
        data = user.top_10_apps
        wrapper(data)
      else
        wrapper(false)
      end
    end

    #####
    desc "user up location"
    params do
      use :auth
      requires :x, :y
    end
    put "update_location" do
      authenticate!

      current_user.update_location(params[:x], params[:y])

      wrapper(true)
    end
  end
end