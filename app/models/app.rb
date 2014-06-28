class App
  include Mongoid::Document
  include Mongoid::Timestamps

  field :appid,       type: Integer
  field :name,   type: String
  field :logo,        type: String
  field :description, type: String
  field :price,       type: Integer

  field :info_hash,   type: Hash

  before_create :fetch_info

  has_and_belongs_to_many :users, inverse_of: :apps
  has_and_belongs_to_many :collectors, class_name: 'User', inverse_of: :top_10_apps

  def fetch_info
    result = RestClient.get "http://itunes.apple.com/cn/lookup?id=#{appid}" rescue nil

    if result
      hash = JSON.parse(result)["results"].first

      self.name = hash["trackName"]
      self.logo = hash["artworkUrl100"]
      self.description = hash["description"]
      self.price = hash["price"]
      self.info_hash = hash
    end
  end

end
