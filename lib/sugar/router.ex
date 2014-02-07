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
        Lager.info "#{conn.method} #{conn.status} /#{Enum.join conn.path_info, "/"}"
        {:ok, conn}
      end
    end
  end

  defmacro get(route, controller, action) do
    quote do
      get unquote(route), do: unquote(
        quote do 
          binding = binding()
          {:ok, conn} = apply(unquote(controller), unquote(action), [var!(conn), Keyword.delete(binding, :conn)])
          Lager.info "GET #{conn.status} /#{Enum.join conn.path_info, "/"}"
          {:ok, conn}
        end
      )
    end
  end

  defmacro post(route, controller, action) do
    quote do
      post unquote(route), do: unquote(
        quote do 
          binding = binding()
          {:ok, conn} = apply(unquote(controller), unquote(action), [var!(conn), Keyword.delete(binding, :conn)])
          Lager.info "POST #{conn.status} /#{Enum.join conn.path_info, "/"}"
          {:ok, conn}
        end
      )
    end
  end

  defmacro put(route, controller, action) do
    quote do
      put unquote(route), do: unquote(
        quote do 
          binding = binding()
          {:ok, conn} = apply(unquote(controller), unquote(action), [var!(conn), Keyword.delete(binding, :conn)])
          Lager.info "PUT #{conn.status} /#{Enum.join conn.path_info, "/"}"
          {:ok, conn}
        end
      )
    end
  end

  defmacro patch(route, controller, action) do
    quote do
      patch unquote(route), do: unquote(
        quote do 
          binding = binding()
          {:ok, conn} = apply(unquote(controller), unquote(action), [var!(conn), Keyword.delete(binding, :conn)])
          Lager.info "PATCH #{conn.status} /#{Enum.join conn.path_info, "/"}"
          {:ok, conn}
        end
      )
    end
  end

  defmacro delete(route, controller, action) do
    quote do
      delete unquote(route), do: unquote(
        quote do 
          binding = binding()
          {:ok, conn} = apply(unquote(controller), unquote(action), [var!(conn), Keyword.delete(binding, :conn)])
          Lager.info "DELETE #{conn.status} /#{Enum.join conn.path_info, "/"}"
          {:ok, conn}
        end
      )
    end
  end

  defmacro options(route, controller, action) do
    quote do
      options unquote(route), do: unquote(
        quote do 
          binding = binding()
          {:ok, conn} = apply(unquote(controller), unquote(action), [var!(conn), Keyword.delete(binding, :conn)])
          Lager.info "OPTIONS #{conn.status} /#{Enum.join conn.path_info, "/"}"
          {:ok, conn}
        end
      )
    end
  end

  defmacro any(route, controller, action) do
    quote do
      match unquote(route), do: unquote(
        quote do 
          binding = binding()
          {:ok, conn} = apply(unquote(controller), unquote(action), [var!(conn), Keyword.delete(binding, :conn)])
          Lager.info "ANY #{conn.status} /#{Enum.join conn.path_info, "/"}"
          {:ok, conn}
        end
      )
    end
  end
end
