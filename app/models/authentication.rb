class Authentication
  include Mongoid::Document
  include Mongoid::Timestamps

  field :uid,         type: Integer
  field :token,       type: String
  field :provider,    type: String
  field :raw_info,    type: String

  belongs_to :user

  validates_presence_of   :uid, :provider, :token
  validates_uniqueness_of :uid, scope: :provider

  class << self
    def locate(auth)
      uid            = auth['id'].to_s
      provider       = auth['provider']
      authentication = where(uid: uid, provider: provider).first

      if authentication
        authentication.update \
          uid:      auth['id'],
          token:    auth['token'],
          provider: auth['provider'],
          raw_info: auth.to_s
      end

      authentication.user.update_user if authentication.try(:user)
      authentication
    end
  end
end
