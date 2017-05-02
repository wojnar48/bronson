require 'byebug'
require_relative 'route'
require 'sourcify'

class Router
  attr_accessor :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    self.routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    routes.each do |route|
      return route if route.matches?(req)
    end
    nil
  end

  def run(req, res)
    @routes.each do |route|
      match = match(req)
      if match
        match.run(req, res)
      else
        res.status = 404
        message = "Resource not found"
        res.set_header(message, 'Resource not found')
      end
    end
  end
end
