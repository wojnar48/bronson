require 'rack'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative '../lib/sql_object'
require 'byebug'

class Image < SQLObject
  self.finalize!
end

class User < SQLObject
  self.table_name = 'images'
  self.finalize!
end

class ImagesController < ControllerBase
  def index
    @images = Image.all
    render('index')
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/images$"), ImagesController, :index
  # get Regexp.new("^/cats/new$"), CatsController, :new
  # post Regexp.new("^/cats$"), CatsController, :create
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
