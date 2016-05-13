defmodule Sugar.Request.HttpToHttps do
  @moduledoc false

  @spec init(Keyword.t) :: Keyword.t
  def init(opts), do: opts

  @spec call(Plug.Conn.t, Keyword.t) :: Plug.Conn.t
  def call(conn, opts \\ []) do
    # WARNING: this does the minimum necessary to get HTTP->HTTPS
    # redirection working (without having to basically reimplement
    # Plug.SSL) with custom HTTPS ports.  Those with more advanced use
    # cases should consider unsetting Sugar's :https_only option and
    # sticking Plug.SSL into their router directly instead (which
    # complicates things for Sugar's HTTPS config, but is
    # hypothetically possible and would enable the use of HSTS and
    # "x-forwarded-proto" headers.
    port = opts[:port] || 8443
    opts = [ host: conn.host <> ":#{port}",
             hsts: false ]
    conn |> Plug.SSL.call(Plug.SSL.init(opts))
  end
end
