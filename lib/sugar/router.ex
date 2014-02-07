defmodule Sugar.Router do
  @moduledoc """
  `Sugar.Router` defines an alternate format for `Plug.Router` 
  routing. Supports all HTTP methods that `Plug.Router` supports,
  currently `get`, `post`, `put`, `patch`, `delete`, and `options`.

  ## Example

      defmodule Routes do
        use Sugar.Router

        get "/", Main, :index
        get "/pages/:slug", Page, :show
      end
  """

  ## Macros
  
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      use Plug.Router
      @before_compile unquote(__MODULE__)
      require Lager
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      match _ do
        {:ok, conn} = Sugar.Controller.not_found var!(conn)
        log conn
        {:ok, conn}
      end

      defp log(conn) do
        if loaded? Config do
          config = apply(Config, :config, [])
          if config[:log] do
            Lager.info "#{conn.method} #{conn.status} /#{Enum.join conn.path_info, "/"}"
          end
        end
      end

      defp loaded?(module) do
        is_tuple :code.is_loaded(module)
      end
    end
  end

  defmacro get(route, controller, action) do
    quote do
      get unquote(route), do: unquote(
        build_match controller, action
      )
    end
  end

  defmacro post(route, controller, action) do
    quote do
      post unquote(route), do: unquote(
        build_match controller, action
      )
    end
  end

  defmacro put(route, controller, action) do
    quote do
      put unquote(route), do: unquote(
        build_match controller, action
      )
    end
  end

  defmacro patch(route, controller, action) do
    quote do
      patch unquote(route), do: unquote(
        build_match controller, action
      )
    end
  end

  defmacro delete(route, controller, action) do
    quote do
      delete unquote(route), do: unquote(
        build_match controller, action
      )
    end
  end

  defmacro options(route, controller, action) do
    quote do
      options unquote(route), do: unquote(
        build_match controller, action
      )
    end
  end

  defmacro any(route, controller, action) do
    quote do
      match unquote(route), do: unquote(
        build_match controller, action
      )
    end
  end

  defp build_match(controller, action) do
    quote do 
      binding = binding()
      {:ok, conn} = apply(unquote(controller), unquote(action), [var!(conn), Keyword.delete(binding, :conn)])
      log conn
      {:ok, conn}
    end
  end
end
