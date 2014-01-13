defmodule Web.Plug do
  import Plug.Connection

  def call(conn, []) do
    conn = case Web.Router.route conn do
      {:match, module, action, _verb} -> apply(module, action, [conn])
      :no_match -> conn |> resp 200, "go away!"
    end

    {:ok, conn |> send}
  end
end

defmodule Hello do
  use Controller
  def index(conn) do
    conn
      |> put_resp_content_type("text/html")
      |> resp 200, "hello world"
  end
end