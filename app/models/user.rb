class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,        type: String
  field :token,       type: String
  field :nickname,    type: String
  field :gender,      type: String
  field :avatar,      type: String
  field :mobile,      type: String
  field :email,       type: String
  field :location,    type: String
  field :description, type: String
  field :expired_at,  type: DateTime

  has_many :authentications
  has_and_belongs_to_many :apps, inverse_of: :users
  has_and_belongs_to_many :top_10_apps, class_name: 'App', inverse_of: :collectors

  before_create :generate_token_and_expired_at

  def save_apps apps
    self.apps = apps
  end

  def save_top_list list
    self.top_10_apps = list
  end

  class << self

    def from_auth(auth_hash)
      locate_auth(auth_hash) ||
      create_from_auth(auth_hash)
    end

    def locate_auth(auth_hash)
      Authentication.locate(auth_hash).try(:user)
    end

    def create_from_auth(auth_hash)
      user = create(
        name:     auth_hash['name'].to_s,
        gender:   auth_hash['gender'],
        nickname: auth_hash['screen_name'].to_s,
        location: auth_hash['location'].to_s,
        avatar:   auth_hash['avatar_large']
      )
      user.add_auth(auth_hash)
      user
    end

    def login(id, token)
      User.where(id: id, token: token).first
    end
  end

  def weibo_account
    authentications.where(provider: 'weibo').first
  end

  def add_auth(auth_hash)
    authentications.create(
      uid:      auth_hash['id'],
      token:    auth_hash['token'],
      provider: auth_hash['provider'],
      raw_info: auth_hash.to_s
    )
  end

  def update_user
    generate_token_and_expired_at if token_expired?
    self.save
  end

  def token_expired?
    Time.now > self.expired_at
  end

  def as_json(opt={})
    {
      id: id.to_s,
      token: token,
      name: name,
      gender: gender,
      location: location,
      nickname: nickname,
      avatar: avatar,
    }
  end

 private

  def generate_token_and_expired_at
    self.expired_at = 1.month.from_now
    self.token = (Digest::MD5.hexdigest "#{SecureRandom.urlsafe_base64(nil, false)}-#{Time.now.to_i}")
  end
end
