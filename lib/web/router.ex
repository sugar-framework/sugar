defmodule Web.Router do
  def route(conn) do
    case match conn.path_info, routes do
      {module, action, verb} -> {:match, module, action, verb}
      _ -> :no_match
    end
  end

  def routes do
    [
      {:get, ["hello"], Hello, :index}
    ]
  end

  defp match(path_info, [{verb, path, module, action} | rest]) do
    if path_info == path do
      {module, action, verb}
    else
      match path_info, rest
    end
  end

  defp match(_path_info, []) do
    false
  end
end