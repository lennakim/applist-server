class UsersController < ApplicationController
  def index
    @users = User.all
    @top_apps = App.top_listed
  end

  def show
  end
end
