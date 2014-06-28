class SessionsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:create]

  def create
    hash_key = params[:hash_key]
    token = params[:token]
    user = User.where(token: token).first
    if user
      cookies[:token] = { value: user.token, expires: 30.days.from_now }
      LoginHistory.confirm hash_key, token
    end
    redirect_to users_path
  end

  def desktop_login
    hash_key = params[:hash_key]
    if token = LoginHistory.confirmed?(params[:hash_key])
      cookies[:token] = { value: User.where(token: token), expires: 30.days.from_now }
      render :json => {success: true, path: user_path(current_user)}
    else
      render :json => {success: false}
    end
  end
end
