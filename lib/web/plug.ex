defmodule Web.Plug do
  import Plug.Connection

  def call(conn, []) do
    # conn = conn
    #   |> put_resp_content_type("text/html")
    #   |> send(200, "Hello!")
    {:ok, conn}
  end
end