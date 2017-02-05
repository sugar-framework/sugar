defmodule Sugar.Router do
  @doc false
  defmacro __using__(_) do
    quote do
      use HttpRouter,
        default_content_type: "text/html; charset=utf-8",
        parsers: [ :json,
                   Sugar.Request.Parsers.XML,
                   :urlencoded,
                   :multipart ]
      @before_compile Sugar.Router
    end
  end

  @doc false
  defmacro __before_compile__(_env) do
    quote do
      def run(opts \\ nil) do
        adapter = Sugar.Config.get(:sugar, :plug_adapter, Plug.Adapters.Cowboy)
        opts = (opts || Sugar.Config.get(__MODULE__))
          |> Keyword.put_new(:http, [])
          |> Keyword.put_new(:https, [])

        opts =
          if is_list(opts[:http]) and opts[:http][:port] do
            opts
              |> Keyword.put(:http, opts[:http]
                |> Keyword.update(:port, 4000, &Sugar.Router.cast_http_port/1))
          else
            opts
          end

        opts =
          if is_list(opts[:https]) and opts[:https][:port] do
            opts
              |> Keyword.put(:https, opts[:https]
                |> Keyword.update(:port, 8443, &Sugar.Router.cast_https_port/1))
          else
            opts
          end

        if is_list(opts[:https]) and opts[:https] != [] do
          adapter.https(__MODULE__, [], opts[:https])
        end

        if opts[:https_only] == true do
          # Sends `403 Forbidden` to all HTTP requests by default; can
          # be configured to use a different handler or plug by
          # setting the :https_only_handler option
          Keyword.get(opts, :https_only_handler, Sugar.Request.HttpsOnly)
            |> adapter.http([port: opts[:https][:port]], opts[:http])
        else
          adapter.http(__MODULE__, [], opts[:http])
        end
      end
    end
  end

  def cast_http_port(port) do
    cast_port(port, 4000)
  end

  def cast_https_port(port) do
    cast_port(port, 8443)
  end

  def cast_port(port, default)
  def cast_port(i, _) when i |> is_integer, do: i
  def cast_port(s, d) do
    case s |> to_string |> Integer.parse do
      {i, _} -> i
      _      -> d
    end
  end
end
