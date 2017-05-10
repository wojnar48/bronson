require 'rack'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative '../lib/sql_object'
require 'byebug'

class Cat < SQLObject
  self.finalize!
end

class CatsController < ControllerBase
  def index
    @cats = Cat.all
    render('index')
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/cats$"), CatsController, :index
  # get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

Rack::Server.start(
 app: app,
 Port: 3000
)
