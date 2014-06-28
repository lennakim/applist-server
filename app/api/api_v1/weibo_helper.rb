require 'net/http'

module WeiboHelper
  def get_user_info(uid, access_token)
    # http://open.weibo.com/wiki/2/users/show

    uri = URI("https://api.weibo.com/2/users/show.json?access_token=#{access_token}&uid=#{uid}")
    Rails.logger.info uri
    ActiveSupport::JSON.decode(Net::HTTP.get(uri))
  end
end