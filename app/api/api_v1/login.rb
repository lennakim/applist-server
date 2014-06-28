class Login < Grape::API

  desc "登录"
  params do
    optional :provider
    requires :user_id, :token
  end
  post "login" do

  end
end