class HomeController < ApplicationController
  def index
    if current_user
      return redirect_to current_user
    end
    hash_key = SecureRandom.urlsafe_base64
    LoginHistory.create hash_key: hash_key
    url = "http://#{Settings.host}/sessions?hash_key=#{hash_key}"
    @check_url = "http://#{Settings.host}/desktop_login/#{hash_key}"
    @qr = RQRCode::QRCode.new(url, size: 4, level: :l)
  end

  def map

  end

  def doc
  end

  def about
    @qr = RQRCode::QRCode.new("http://#{Settings.host}/users", size: 4, level: :l)
  end
end
