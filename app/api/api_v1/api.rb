require 'grape-swagger'

class API < Grape::API
  helpers ::Helper
  helpers WeiboHelper

  prefix "api"
  version 'v1'
  content_type :json, "application/json;charset=UTF-8"
  format :json

  before do
    header['Access-Control-Allow-Origin'] = '*'
    header['Access-Control-Request-Method'] = '*'
  end

  mount Login

  add_swagger_documentation mount_path: 'doc.json', api_version: 'v1'
end