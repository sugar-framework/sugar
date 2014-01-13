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

  defp match(conn, [{verb, path, module, action} | rest]) do
    if conn.path_info === path && conn.method === verb do
      {module, action, verb}
    else
      match conn.path_info, rest
    end
  end

  defp match(_path_info, []) do
    false
  end
end