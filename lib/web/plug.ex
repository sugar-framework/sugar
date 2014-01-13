defmodule Web.Plug do
  import Plug.Connection

  def call(conn, []) do

    body = case conn.path_info do
      ["hello"] -> "Hello world"
      _ -> "go away!"
    end

    conn = conn
      |> put_resp_content_type("text/html")
      |> send(200, body)

    {:ok, conn}
  end
end