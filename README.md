# Sugar

[![Build Status](https://img.shields.io/travis/sugar-framework/sugar.svg?style=flat)](https://travis-ci.org/sugar-framework/sugar)
[![Coverage Status](https://img.shields.io/coveralls/sugar-framework/sugar.svg?style=flat)](https://coveralls.io/r/sugar-framework/sugar)
[![Hex.pm Version](http://img.shields.io/hexpm/v/sugar.svg?style=flat)](https://hex.pm/packages/sugar)
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/sugar-framework/sugar?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Modular web framework for Elixir

## Goals

- Speed. Sugar shouldn't be slow and neither should your project.
- Ease. Sugar should be simple because simple is easy to learn and use.
- Effective. Sugar should aid development. You have better things to which to devote your time.

## Reason for Existence

Why build this when [Dynamo](https://github.com/dynamo/dynamo), [Weber](http://elixir-web.github.io/weber/), and [Phoenix](https://github.com/phoenixframework/phoenix) exist with growing communities? While these projects are great in their own right, Sugar aims to be another contender, sparking more development on all three projects (and/or others that may follow) and giving developers another option when deciding what framework fits their needs best. Sugar may even strive to shake things up just as [ChicagoBoss](http://www.chicagoboss.org/) has done.

## Getting Started

```
# Clone this repo
git clone https://github.com/sugar-framework/simple.git
cd simple

# Get project dependencies
mix deps.get

# Start the web server
mix server # or `iex -S mix server` if you want access to iex
```

### Configurations

Sugar needs to be configured in your application's `config/config.exs` in order to work.  The following options are supported:

#### `config :sugar, router: MyWebsite.Router`

Tells Sugar which module to use as a router.  This module should implement `Sugar.Router`, and should have at least one route defined.  This is required.

#### `config :sugar, plug_adapter: Plug.Adapters.Cowboy`

Tells Sugar which web server to use to handle HTTP(S) requests.  Cowboy is currently the only supported option, and Sugar will default to using `Plug.Adapters.Cowboy` if this is omitted.

#### `config :sugar, MyWebsite.Router, ...`

Tells Sugar how the specified router should be configured.  The following options are supported:

- `http`: takes a key/value list with options to configure the specified `:plug_adapter`.  Of particular usefulness:
    - `ip`: IP address the server should bind to.  Should be a tuple in the format `{x,y,z,w}`.  Defaults to accepting connections on any IP address.
    - `port`: port the server should listen on.  Defaults to 4000.
	- `acceptors`: the number of acceptors for the listener.  Defaults to 100.
	- `max_connections`: the maximum number of connections supported.  Defaults to `:infinity`.
	- `compress`: whether or not the bodies of responses should be compressed.  Defaults to `false`.
- `https`: takes a key/value list with the same options as `http`, or can be set to `false` if you don't want to enable HTTPS.  The following additional options(along with others from Erlang's "ssl" module) are supported:
    - `password`: a plaintext, secret password for the private SSL key (if it's password-protected)
	- `keyfile`: path to the PEM-format private key file to use
	- `certfile`: path to the PEM-format certificate to use

#### Example

```elixir
use Mix.exs

config :sugar, router: MyWebsite.Router

config :sugar, MyWebsite.Router,
  http: [
    port: 80
  ],
  https: [
    port: 443,
    password: "OMG_SUPER_SECRET",
	keyfile: "/path/to/key.pem",
	certfile: "/path/to/cert.pem"
  ]
```

### Routers

Because Sugar builds upon [Plug](https://github.com/elixir-lang/plug), it leverages `Plug.Router` to do the heavy lifting in routing your application, adding an alternate DSL.

Routes are defined with the form:

    method route [guard], controller, action

`method` is `get`, `post`, `put`, `patch`, `delete`, or `options`, each responsible for a single HTTP method. `method` can also be `any`, which will match on all HTTP methods. `controller` is any valid Elixir module name, and `action` is any valid function defined in the `controller` module.

#### Example

```elixir
defmodule Router do
  use Sugar.Router

  get "/", Hello, :index
  get "/pages/:id", Hello, :show
  post "/pages", Hello, :create
  put "/pages/:id" when id == 1, Hello, :show
end
```

### Controllers

All controller actions should have an arrity of 2, with the first argument being a `Plug.Conn` representing the current connection and the second argument being a `Keyword` list of any parameters captured in the route path.

Sugar bundles these response helpers to assist in sending a response:

- `render/2` - sends a normal response
- `not_found/1` - sends a 404 (Not found) response

#### Example

```elixir
defmodule Hello do
  use Sugar.Controller

  def index(conn, []) do
    render conn, "index.html.eex", []
  end

  def show(conn, args) do
    render conn, "show.html.eex", args
  end

  def create(conn, []) do
    render conn, "create.html.eex", []
  end
end
```

## Todo Items

- basic authentication (?)
- Development error page
- Caching
    - Compiled HTML
    - Application Data
    - Adapters
        - ETS

## Who's behind this?

Why, the [contributors](https://github.com/sugar-framework/sugar/graphs/contributors), of course! Would you consider being one? Please send a pull request :)

## How to start contributing

The main product of this repository is the example terms in the file [CONTRIBUTING.md](https://github.com/sugar-framework/sugar/blob/master/CONTRIBUTING.md). This project uses those guidelines as the basis for its own development process. Please refer to that file.

## License

Sugar is released under the MIT License.

See [LICENSE](https://github.com/sugar-framework/sugar/blob/master/LICENSE) for details.
