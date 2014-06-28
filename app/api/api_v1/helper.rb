module Helper
  def authenticate!
    current_user or raise AuthorizationError
  end

  def json_wrapper(mes = 'successful', code = 0, data)
    {message: mes, code: code, data: data}
  end

  alias_method :wrapper, :json_wrapper

  def paginate(collection)
    collection.page(params[:page]).per(params[:per_num]).tap do |data|
      header "X-Total",       data.total_count.to_s
      header "X-Total-Pages", data.num_pages.to_s
      header "X-Per-Num",     params[:per_num].to_s
      header "X-Page",        data.current_page.to_s
      header "X-Next-Page",   data.next_page.to_s
      header "X-Prev-Page",   data.prev_page.to_s
    end
  end

  def current_user
    request = Grape::Request.new(env)
    headers = @request.headers
    token = headers['X-Token'].present? ? headers['X-Token'] : params[:token]
    @current_user ||= User.where(token: token).first
  end

  def permit!(klass, user)
    raise PermissionDeniedError if klass.try(:user) != user
  end

   def login_failed
    wrapper('login failed', 10002, false)
  end

  def token_expired
    wrapper('token expired', 10004, false)
  end
end

class Error < Grape::Exceptions::Base
  attr :code, :text

  def initialize(opts={})
    @code    = opts[:code]   || ''
    @text    = opts[:text]   || ''
    @status  = opts[:status] || ''

    @message = {message: @text, code: @code}
  end
end

class AuthorizationError < Error
  def initialize
    super code: 10001, text: 'Authorization failed', status: 403
  end
end

class PermissionDeniedError < Error
  def initialize
    super code: 10007, text: 'Permission denied', status: 403
  end
end
