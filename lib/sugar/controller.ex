# awesome example by @josevalim: https://gist.github.com/josevalim/7432084
defmodule Sugar.Controller do
  import Plug.Connection

  @doc """
  `__using__/1` macro used to add necessary items to a controller.
  """
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end

  def render(conn, _template) do
    {:ok, send_resp(conn, 200, "hello world")}
  end

  def halt!(conn) do
    {:ok, send_resp(conn, 401, "")}
  end
end