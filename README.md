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

Each Route object stores a regex pattern, http method, controller class and action name which define how incoming HTTP requests get matched to actions that live on a specific controller. Once a request is matched to one of the Routes, the run method instantiates the correct controller and invokes the requested action by calling the invoke_action method that lives on the ControllerBase class.

![bronson router_run_image][bronson_router_run]

To mimic rails functionality, the invoke_action method uses convention to give users the ability to skip the template name when defining actions on the controller. It will automatically look for a template name that matches the name of the action on the controller. In Rails fashion, it also ensures that templates are not double rendered by calling the already_built_response? helper method.

![bronson invoke_action_image][bronson_invoke_action]

### ControllerBase Class

Provides some of the basic functionality that is familiar to users of Rails' ActionController::Base. By inheriting from ControllerBase, subclasses automatically know where to look for templates that need to be rendered via the render method.

![bronson render_image][bronson_render]

### SQLObject ORM

Exposes functionality to query the database without having to write SQL queries in a similar fashion to ActiveRecord::Base in Rails. It uses the active_support/inflector gem to automatically translate the class names to tableized versions. It also provides a table_name= method to give users the ability to override the defaults for names that do not lend themselves to tableization (Human -> humen).

![bronson table_name][bronson_table_name]

At present, users have the ability to search, fetch and save records but future releases of Bronson will also include the ability to define associations between records.

### Example

To run the example:
1. clone the repo
2. cd into the project directory
3. run `bundle install`
2. run `ruby demo/start.rb`
3. navigate to `localhost:3000/` or `localhost:3000/images`

### Future Direction
- Include associations
- Add `new` method to conveniently start project
- Add ability to serve static assets like stylesheets and JavaScript

[bronson_table_name]: docs/images/table_name=.png
[bronson_render]: docs/images/render.png
[bronson_invoke_action]: docs/images/invoke_action.png
[bronson_router_run]: docs/images/route_run.png
[bronson_router]: docs/images/router_routes.png
[bronson_logo]: docs/images/bronson_logo.png
[bronson_rack]: docs/images/rack_proc_server.png
