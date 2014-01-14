defmodule Web.Router do
  @moduledoc """
  `Web.Router` allows for the appropriate routing of the application.
  """

  ## API

  @doc """
  `route/1` runs `Web.Router.match/2` against the current connection and
  the available parsed routes for the application.

  ## Arguments

    - `conn` - `Plug.Conn` - connection instance

  ## Returns

    - `:no_match` - no match could be made with availble routes
    - `{:match, module, action}` - a match was found, with `module` and `action`
      representing the module and function name for the matched route
  """
  def route(conn) do
    case match conn, routes do
      {module, action} -> {:match, module, action}
      _ -> :no_match
    end
  end

  defp routes do
    [
      {"GET", ["hello"], Hello, :index}
    ]
  end

  defp preparsed_routes do 
    [
      # what should be captured?
      # - route
      # - verb
      # - controller (can be in route)
      # - action (can be in route)
      # - name (opt.)
      [route: "/:controller/:action", verb: :GET, name: "default"]
    ]
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
    parse_route(route) ++ parsed
  end
  def parse_routes([]) do
    []
  end

  @doc """
  `parse_routes/1` converts the routes to the required format for `match/2`

  ## Arguments

    - `route` - Keyword List - route to be parsed

  ## Returns

    - `{verb, path, module, action}`
  """
  def parse_route(route) do
    rte = route[:route]
    verb = route[:verb]
    controller = route[:controller]
    action = route[:action]
    name = route[:name]

    path = String.split String.strip(rte, ?/), "/"


  end
end