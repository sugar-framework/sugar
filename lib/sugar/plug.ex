defmodule Sugar.Plug do
  import Plug.Connection

  @doc """
  `call/2` acts as the main interface to the request. It calls the router to pass
  the request to the appropriate controller.

  ## Arguments

    - `conn` - `Plug.Conn` - connection instance
    - `opts` - `List` - options?

  ## Returns

    - `{:ok, Plug.Conn[state: :sent]}`
  """
  def call(conn, []) do
    conn = case Sugar.Router.find_route conn do
      {:match, module, action} -> apply(module, action, [conn])
      :no_match -> conn |> resp 200, "go away!"
    end

    {:ok, conn |> send_resp}
  end
end