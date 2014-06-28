class App
  include Mongoid::Document
  include Mongoid::Timestamps

  field :appid,       type: Integer
  field :name,        type: String
  field :logo,        type: String
  field :description, type: String
  field :price,       type: Integer
  field :info_hash,   type: Hash

  field :users_count, type: Integer, default: 0
  field :collectors_count, type: Integer, default: 0

  field :categories,  type: Array

  validates :appid, uniqueness: true

  before_create :fetch_info

  has_and_belongs_to_many :users, inverse_of: :apps
  has_and_belongs_to_many :collectors, class_name: 'User', inverse_of: :top_10_apps

  before_save :check_and_save_counts

  scope :top_listed, -> { desc(:collectors_count) }
  scope :top_installed, -> { desc(:users_count) }
  scope :recent, -> { order_by(created_at: :desc) }

  def appstore_path
    info_hash["trackViewUrl"]
  end

  def related_apps
    App.in(categories: self.categories).ne(appid: self.appid)
  end

  def fetch_info
    result = RestClient.get "http://itunes.apple.com/cn/lookup?id=#{appid}" rescue nil

    if result
      hash = JSON.parse(result)["results"].first

      self.name = hash["trackName"]
      self.logo = hash["artworkUrl100"]
      self.description = hash["description"]
      self.price = hash["price"]
      self.categories = hash["genreIds"]
      self.info_hash = hash
    end
  end

  def check_and_save_counts
    self.users_count = users.length
    self.collectors_count = collectors.length
  end


  def as_json(opt={})
    {
      id: id.to_s,
      appid: appid,
      name: name,
      logo: logo,
      description: description,
      price: price,
      appstore_path: appstore_path
    }
  end
end
