class CommentsController < ApplicationController
  inherit_resources
  belongs_to :app

  def create
    super do |format|
      format.js
    end
  end

  private

  def build_resource_params
    [params.fetch(:comment, {}).permit(:content, :user_id)]
  end
end
