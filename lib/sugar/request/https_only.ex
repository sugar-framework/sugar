defmodule Sugar.Request.HttpsOnly do
  @moduledoc false
  import Plug.Conn

  @spec init(Keyword.t) :: Keyword.t
  def init(opts), do: opts

  @spec call(Plug.Conn.t, Keyword.t) :: Plug.Conn.t
  def call(conn, _opts) do
    conn |> send_resp(403, "Forbidden")
  end
end