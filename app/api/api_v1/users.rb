class Users < Grape::API

  resources :users do
    desc "get user info"
    params do
      requires :user_id
    end
    get "/:user_id" do
      user = User.find(params[:user_id])

      if user
        wrapper(user)
      else
        wrapper(false)
      end
    end
  end
end