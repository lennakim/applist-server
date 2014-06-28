require 'grape-swagger'

class API < Grape::API

  helpers ::Helpers
  helpers WeiboHelpers

  prefix "api"
  version 'v1'
  content_type :json, "application/json;charset=UTF-8"
  format :json

  before do
    header['Access-Control-Allow-Origin'] = '*'
    header['Access-Control-Request-Method'] = '*'
  end

  add_swagger_documentation mount_path: 'doc.json', markdown: true, api_version: 'v1'
end