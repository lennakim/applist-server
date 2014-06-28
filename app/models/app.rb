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
  field :screenshotUrls, type: Array
  field :trackName, type: String
  field :genres, type: String
  field :fileSizeBytes, type: String
  field :userRatingCount, type: String

  validates :appid, uniqueness: true

  before_create :fetch_info

  has_and_belongs_to_many :users, inverse_of: :apps
  has_and_belongs_to_many :collectors, class_name: 'User', inverse_of: :top_10_apps

  before_save :check_and_save_counts

  scope :top_listed, -> { desc(:collectors_count) }
  scope :top_installed, -> { desc(:users_count) }
  scope :recent, -> { order_by(created_at: :desc) }

  def self.lookup_app(app_ids)
    arr = app_ids.split(',')

    apps = []
    arr.each do |app_id|
      app = App.find_or_create_by(appid: app_id)
      apps << app
    end

    apps
  end

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

      self.name = hash["trackName"].to_s
      self.logo = hash["artworkUrl100"].to_s
      self.description = hash["description"].to_s
      self.price = hash["price"].to_s
      self.categories = hash["genreIds"]
      self.screenshotUrls = hash["screenshotUrls"]
      self.trackName = hash["trackName"].to_s
      self.genres = hash["genres"].to_s
      self.fileSizeBytes = hash["fileSizeBytes"].to_s
      self.userRatingCount = hash["userRatingCount"].to_s
      self.info_hash = hash
    end
  end

  def check_and_save_counts
    self.users_count = users.length
    self.collectors_count = collectors.length
  end

  def as_json(opt={})
    {
      id: id.to_s.to_s,
      appid: appid.to_s,
      name: name.to_s,
      logo: logo.to_s,
      description: description.to_s,
      price: price.to_s,
      appstore_path: appstore_path.to_s,
      screenshotUrls: screenshotUrls.to_s,
      trackName: trackName.to_s,
      genres: genres.to_s,
      fileSizeBytes: fileSizeBytes.to_s,
      userRatingCount: userRatingCount.to_s
    }
  end
end
