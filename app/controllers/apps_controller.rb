class AppsController < ApplicationController
  inherit_resources

  def show
    @related_apps = resource.related_apps.top_listed.limit(12)
  end
end
