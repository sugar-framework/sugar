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
        opts = opts || Sugar.Config.get(__MODULE__)

        if opts[:https] do
          adapter.https __MODULE__, [], opts[:https]

          if opts[:https_only] do
            # Sends `403 Forbidden` to all HTTP requests
            adapter.http Sugar.Request.HttpsOnly, [], opts[:http]
          else
            adapter.http __MODULE__, [], opts[:http]
          end
        else
          adapter.http __MODULE__, [], opts[:http]
        end
      end
    end
  end
end
