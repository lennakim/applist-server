class App
  include Mongoid::Document
  include Mongoid::Timestamps

  field :appid,       type: Integer
  # field :name,   type: String
  # field :logo,        type: String
  # field :description, type: String
  # field :price,       type: Integer

  # field :info_hash,   type: Hash

  has_and_belongs_to_many :users, inverse_of: :apps
  has_and_belongs_to_many :collectors, class_name: 'User', inverse_of: :top_10_apps

  def set_info
    result = RestClient.get "http://itunes.apple.com/cn/lookup?id=#{appid}" rescue nil

    @data ||= JSON.parse(result)["results"].first if result
  end

  def value_of key
    if @data
      @data[key]
    else
      raise 'call App#info first'
    end
  end

end
