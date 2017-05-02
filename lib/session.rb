require 'json'

class Session
  def initialize(req)
    if req.cookies['_rails_lite_app']
      @cookies = JSON.parse(req.cookies['_rails_lite_app'])
    else
      @cookies = {}
    end
  end

  def [](key)
    @cookies[key]
  end

  def []=(key, val)
    @cookies[key] = val
  end

  def store_session(res)
    res.set_cookie('_rails_lite_app', {
      path: '/', value: @cookies.to_json
      })
  end
end
