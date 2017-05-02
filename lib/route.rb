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
    match_data = pattern.match(req.path)
    route_params = {}
    unless match_data.nil?
      debugger
      names = match_data.names
      names.each do |name|
        route_params[name] = match_data[name]
      end
    end
    controller_class.new(req, res, route_params).invoke_action(action_name)
  end
end
