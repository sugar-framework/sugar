defmodule Sugar.Request.HttpsOnly do
  @moduledoc false
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    conn |> send_resp(403, "Forbidden")
  end
end