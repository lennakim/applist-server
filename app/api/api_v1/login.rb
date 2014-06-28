class Login < Grape::API

  desc "登录"
  params do
    optional :provider
    requires :user_id, :token
  end

  post 'login' do
    token = params[:token]
    user_id = params[:user_id]
    provider = params[:provider]

    status(200)

    if provider.blank? || provider == 'self'
      user = User.login(user_id, token)

      if user
        if user.token_expired?
          token_expired
        else
          wrapper(user)
        end
      else
        wrapper(false)
      end
    else
      result = get_user_info(user_id, token)

      if result.has_key?('id')
        result['provider'] = provider
        result['token'] = token
        user = User.from_auth(result)

        wrapper(user)
      else
        login_failed
      end
    end
  end
end
