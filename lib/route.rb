class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    path = req.path
    method = req.request_method.downcase.to_sym
    pattern =~ path && http_method == method
  end

  def run(req, res)
    controller_class.new(req, res, {}).invoke_action(action_name)
  end
end
