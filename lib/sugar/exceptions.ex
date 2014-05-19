defmodule Sugar.Exceptions do
  @behaviour Plug.Wrapper
  import Plug.Conn

  def init(opts), do: opts

  def wrap(conn, _opts, fun) do
    IO.puts "wrapping"
    try do
      fun.(conn)
    catch
      _,_ ->
        IO.puts "wrapping"
        IO.inspect System.stacktrace
        conn
          |> resp(500, System.stacktrace)
          |> send_resp
    end
  end
end
