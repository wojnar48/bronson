require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext'
require 'erb'
require 'byebug'
require_relative './session'

class ControllerBase
  attr_accessor :req, :res, :params, :already_built_response

  def initialize(req, res, route_params)
    @already_built_response = false
    @req = req
    @res = res
    @params = route_params.merge(req.params)
  end

  def already_built_response?
    @already_built_response == true
  end

  def redirect_to(url)
    raise DoubleRenderError if already_built_response?
    self.res.status = 302
    self.res.set_header('Location', url)
    session.store_session(@res)
    self.already_built_response = true
  end

  def render_content(content, content_type)
    raise DoubleRenderError if already_built_response?
    @res['Content-Type'] = content_type
    @res.write(content)
    session.store_session(@res)
    self.already_built_response = true
  end

  def render(template_name)
    controller_name = "#{self.class.to_s}".underscore
    path = "views/#{controller_name}/#{template_name}.html.erb"
    content = ERB.new(File.read(path)).result(binding)
    render_content(content, "text/html")
    self.already_built_response = true
  end

  def session
    @session ||= Session.new(@req)
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless already_built_response?
  end
end
