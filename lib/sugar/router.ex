defmodule Sugar.Router do
  @routes []
  @moduledoc """
  `Sugar.Router` allows for the appropriate routing of the application.

  defmodule Test do
    use Sugar.Router

    route get("/", Controller, :action)
      |> get("/login", Controller, :show_login)
      |> post("/login", Controller, :handle_login)

  end
  """

  ## API

  @doc """
  `route/1` runs `Sugar.Router.match/2` against the current connection and
  the available parsed routes for the application.

  ## Arguments

    - `conn` - `Plug.Conn` - connection instance

  ## Returns

    - `:no_match` - no match could be made with availble routes
    - `{:match, module, action}` - a match was found, with `module` and `action`
      representing the module and function name for the matched route
  """
  def find_route(conn) do
    case match conn, routes do
      {module, action} -> {:match, module, action}
      _ -> :no_match
    end
  end

  defp routes do
    @routes
  end

  ## Helper functions

  @doc """
  `match/2` tests the current `Plug.Conn.path_info` and `Plug.Conn.verb` against
  parsed routes in the order of their declaration.

  ## Arguments

    - `conn` - `Plug.Conn` - connection instance
    - `routes` - `List` - parsed routes of the form `{verb, path, module, action}`

  ## Returns

    - `false` - no match available
    - `{module, action}` - `module` and `action` for matched route
  """
  def match(Plug.Conn[method: method, path_info: path_info], [{verb, path, module, action} | _rest]) 
    when path_info === path and method === verb do
    {module, action}
  end
  def match(conn, [_route | rest]) do
    match conn, rest
  end
  def match(_conn, []) do
    false
  end

  @doc """
  `parse_routes/1` converts the routes to the required format for `match/2`

  ## Arguments

    - `routes` - `List` - routes to be parsed

  ## Returns

    - `routes` - `List` of `Tuple`
  """
  def parse_routes([route | rest]) do
    parsed = parse_routes rest
    [parse_route(route)] ++ parsed
  end
  def parse_routes([]) do
    []
  end

  @doc """
  `parse_route/1` converts the routes to the required format for `match/2`

  ## Arguments

    - `route` - Keyword List - route to be parsed

  ## Returns

    - `{verb, path, module, action}`
  """
  def parse_route(route) do
    rte = route[:route]
    verb = String.Chars.to_string route[:verb]
    controller = route[:controller]
    action = route[:action]
    name = route[:name]

    path = String.split String.strip(rte, ?/), "/"

    {verb, path, controller, action}
  end

  ## Macros
  
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      @before_compile unquote(__MODULE__)
      @routes []
    end
  end

  defmacro __before_compile__(env) do
    routes = Module.get_attribute(env.module, :routes)
    arg   = quote do: arg

    IO.inspect routes
 
    # Compile each route to a clause in cond.
    # Each clause in a cond:
    #
    #    left -> right
    #
    # Compiles to an AST node in the format:
    #
    #   { [left], meta, right }
    #
    # We will do the same here.
    # routes = lc { condition, block } inlist routes do
    #   condition = add_arg(condition, arg)
    #   { [condition], [], block }
    # end
 
    # # Now we pack all clauses/routes together in
    # # a -> node which we will pass to cond.
    # arrow = { :->, [], routes }
 
    # quote do
    #   def run_routes(arg) do
    #     # Make the argument available in the block as the "number" var.
    #     # This is usually seen as bad practice but here it goes as an example.
    #     var!(number) = arg
    #     cond do: unquote(arrow)
    #   end
    # end
  end

  defmacro get(route, opts) do
    add_route(:get, route, opts)
  end

  defmacro post(route, opts) do
    add_route(:post, route, opts)
  end

  defmacro put(route, opts) do
    add_route(:put, route, opts)
  end

  defmacro delete(route, opts) do
    add_route(:delete, route, opts)
  end

  defmacro any(route, opts) do
    add_route(:any, route, opts)
  end

  defp add_route(verb, route, opts) do
    verb = Macro.escape(verb)
    route = Macro.escape(route)
    opts = Macro.escape(opts)
    quote do
      @routes [{unquote(verb), unquote(route), unquote(opts)} | @routes]
    end
  end

  # defmacro rule(condition, do: block) do
  #   condition = Macro.escape(condition)
  #   block     = Macro.escape(block)
  #   quote do
  #     @rules [{ unquote(condition), unquote(block) }|@rules]
  #   end
  # end
end