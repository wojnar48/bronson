require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res)
    @already_built_response = false
    @req = req
    @res = res
  end

  def already_built_response?
    @already_built_response == true
  end

  def redirect_to(url)
    raise DoubleRenderError if already_built_response?
    @res.status = 302
    @res.set_header('Location', url)
    @already_built_response = true
    session.store_session(@res)
  end

  def render_content(content, content_type)
    raise DoubleRenderError if already_built_response?
    @res['Content-Type'] = content_type
    @res.write(content)
    @already_built_response = true
    session.store_session(@res)
  end

  def render(template_name)
    controller_name = "#{self.class.to_s}".underscore
    path = "views/#{controller_name}/#{template_name}.html.erb"
    content = ERB.new(File.read(path)).result(binding)
    render_content(content, "text/html")
    @already_built_response = true
  end

  def session
    @session ||= Session.new(@req)
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless @already_built_response
  end
end
