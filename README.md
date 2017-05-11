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

Rack middleware is used via the rack gem to provide a convenient interface for working with client requests and responses. Because Rack requires and object that responds to the call method, Bronson uses a Proc to construct such an object which is then passes to Rack Server's start method as visible in the code snippet below.

![bronson rack_image][bronson_rack]


### Route Class


### ControllerBase Class





### Example


[bronson_logo]: docs/images/bronson_logo.png
[bronson_rack]: docs/images/rack_proc_server.png
