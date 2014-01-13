defmodule Web.Plug do
  import Plug.Connection

  @module Hello
  @action :index

  def call(conn, []) do
    conn = case conn.path_info do
      ["hello"] -> Module.function(@module, @action, 1).(conn)
      _ -> conn |> resp 200, "go away!"
    end

    # conn = conn
    #   |> put_resp_content_type("text/html")
    #   |> resp(200, body)
    #   |> send

    {:ok, conn |> send}
  end
end

defmodule Hello do
  import Plug.Connection
  def index(conn) do
    conn
      |> put_resp_content_type("text/html")
      |> resp 200, "hello world"
  end
end