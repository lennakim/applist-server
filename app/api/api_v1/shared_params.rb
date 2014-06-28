module SharedParams
  extend Grape::API::Helpers

  params :auth do
    requires :token, desc: 'User Token'
  end
end