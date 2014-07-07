class AppInfo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :udid,       type: String
  field :app_track_id,   type: Integer
  field :bundle_id,  type: String
  field :scheme_url, type: String
  field :trackName,  type: String
  field :info_hash,  type: Hash

  after_create :get_app_info_by_bundle_id

  def self.upload(udid, scheme_url, bundle_id)
    appinfo = AppInfo.find_or_create_by(bundle_id: bundle_id)

    appinfo.udid = udid
    appinfo.scheme_url = scheme_url
    appinfo.save
    appinfo
  end

  def get_app_info_by_bundle_id
    result = RestClient.get "http://itunes.apple.com/cn/lookup?bundleId=#{bundle_id}" rescue nil

    if result
      hash = JSON.parse(result)["results"].first

      puts hash["trackId"].to_s
      if hash && hash.has_key?('trackId')
        self.app_track_id = hash["trackId"]
        self.bundle_id = hash["bundleId"]
        self.trackName = hash['trackName']
        self.info_hash = hash
      end
    end
  end

  def as_json(opt={})
    {
      id: id.to_s,
      udid: udid,
      track_id: app_track_id,
      bundle_id: bundle_id,
      trackName: self.trackName,
      scheme_url: scheme_url
    }

  end
end