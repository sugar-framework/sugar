defmodule Sugar.Exceptions do
  @moduledoc """
  Catches runtime exceptions for displaying an error screen instead of an empty
  response in dev environments.
  """
  @behaviour Plug.Wrapper
  import Plug.Conn

  @doc """
  Inits options on compile

  ## Arguments

  * `opts` - `Keyword`

  ## Returns

  `Keyword`
  """
  def init(opts), do: opts

  @doc """
  Wraps a connection for catching exceptions

  ## Arguments

  * `conn` - `Plug.Conn`
  * `opts` - `Keyword`
  * `fun` - `Function`

  ## Returns

  `Plug.Conn`
  """
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
