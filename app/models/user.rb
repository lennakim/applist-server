class User
  include Mongoid::Document
  include Mongoid::Timestamps

  has_and_belongs_to_many :apps, inverse_of: :users
  has_and_belongs_to_many :top_10_apps, class_name: 'App', inverse_of: :collectors

  field :name,  type: String

  def save_apps apps
    self.apps = apps
  end

  def add_to_list *apps
    self.top_10_apps.concat apps
  end
end
