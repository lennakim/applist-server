class LoginHistory < Ohm::Model

  attribute :hash_key
  attribute :token

  index :hash_key

  def self.confirmed? hash_key
    item = self.find(hash_key: hash_key).first
    item.token
  end

  def self.confirm hash_key, token
    item = self.find(hash_key: hash_key).first
    item.token = token
    item.save
  end
end

