class HomeController < ApplicationController
  def index
    hash_key = SecureRandom.urlsafe_base64
    LoginHistory.create hash_key: hash_key
    @url = "http://#{Settings.host}/desktop_login/#{hash_key}"
    @qr = RQRCode::QRCode.new(@url, size: 4, level: :l)
  end

  def doc
  end
end
