require 'json'

class Session
  attr_accessor :cookies

  def initialize(req)
    if req.cookies['_rails_lite_app']
      @cookies = JSON.parse(req.cookies['_rails_lite_app'])
    else
      @cookies = {}
    end
  end

  def [](key)
    self.cookies[key]
  end

  def []=(key, val)
    self.cookies[key] = val
  end

  def store_session(res)
    res.set_cookie('_rails_lite_app', {
      path: '/', value: cookies.to_json
      })
  end
end
