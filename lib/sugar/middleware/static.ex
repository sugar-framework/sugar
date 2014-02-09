defmodule Sugar.Middleware.Static do
  import Plug.Connection

  def call(conn, []) do
    {:ok, conn}
  end
end