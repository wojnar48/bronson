## A Pocket ORM / MVC

Bronson is a lightweight ORM and MVC package implemented in Ruby that mimics some of the basic functionality of Rails.

![bronson image][bronson_logo]

### Technologies
- `Ruby`
- `SQL` for ORM queries
- `Rack` for request/response interface and simple demo server
- `Erb` for template rendering

## Features & Highlights:

### Rack Middleware & Router

Rack middleware is used via the rack gem to provide a convenient interface for working with client requests and responses. Because Rack requires an object that responds to the call method, Bronson uses a Proc to construct such an object which is then passes to Rack Server's start method as visible in the code snippet below.

![bronson rack_image][bronson_rack]


### Route & Router Classes

Give users the ability to define custom routes using regular expressions which is akin to the functionality that the routes file provides in Rails. The Router instantiates and stores the different Routes defined by the client.

![bronson router_image][bronson_router]

Each Route object stores a regex pattern, http_method, controller class and action name which define how incoming HTTP requests get matched to actions that live on a specific controller. Once a request is matched to one of the Routes, the run method instantiates the correct controller and invokes the requested action by calling the invoke_action method that lives on the ControllerBase class.

![bronson router_run_image][bronson_router_run]

### ControllerBase Class

![bronson invoke_action_image][bronson_invoke_action]





### Example

[bronson_invoke_action]: docs/images/invoke_action.png
[bronson_router_run]: docs/images/router_run.png
[bronson_router]: docs/images/router_routes.png
[bronson_logo]: docs/images/bronson_logo.png
[bronson_rack]: docs/images/rack_proc_server.png
