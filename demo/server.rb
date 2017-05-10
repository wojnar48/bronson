require 'rack'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative '../lib/sql_object'
require 'byebug'

class Cat < SQLObject
  self.finalize!
end

class Human < SQLObject
  self.table_name = 'humans'
  self.finalize!
end

class CatsController < ControllerBase
  def create
    @cat = Cat.new
    @cat.name = params['name']

    Human.table_name = 'humans'
    @owner = Human.new
    @owner.fname = params['fname']
    @owner.lname = params['lname']
    @owner.save

    @cat.owner_id = @owner.id
    @cat.save

    self.redirect_to('cats')
  end

  def new
    @cat = Cat.new
    render('new')
  end

  def index
    # debugger
    @cats = Cat.all
    render('index')
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/cats$"), CatsController, :index
  get Regexp.new("^/cats/new$"), CatsController, :new
  post Regexp.new("^/cats$"), CatsController, :create
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
