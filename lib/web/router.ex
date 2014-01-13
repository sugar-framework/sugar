defmodule Web.Router do
  def route(conn) do
    case match conn, routes do
      {module, action, verb} -> {:match, module, action, verb}
      _ -> :no_match
    end
  end

  def routes do
    [
      {"GET", ["hello"], Hello, :index}
    ]
  end

  defp match(Plug.Conn[method: method, path_info: path_info], [{verb, path, module, action} | _rest]) 
    when path_info === path and method === verb do
    {module, action, verb}
  end

  defp match(conn, [_route | rest]) when is_list(rest) do
    match conn, rest
  end

  defp match(_conn, []) do
    false
  end
end