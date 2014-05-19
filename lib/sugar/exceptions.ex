defmodule Sugar.Exceptions do
  @behaviour Plug.Wrapper
  import Plug.Conn

  def init(opts), do: opts

  def wrap(conn, _opts, fun) do
    try do
      fun.(conn)
    catch
      _,_ ->
        conn
          |> resp(500, System.stacktrace)
          |> send_resp
    end
  end
end
