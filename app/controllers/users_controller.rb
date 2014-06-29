class UsersController < ApplicationController
  inherit_resources

  def index
    @users = User.all
    respond_with do |format|
      format.html
      format.js
    end
  end
end
