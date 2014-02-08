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
      import Plug.Connection
      use Plug.Router
      use Sugar.Middleware
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      match _ do
        {:ok, conn} = Sugar.Controller.not_found var!(conn)
        Sugar.App.log :debug, "#{conn.method} #{conn.status} /#{Enum.join conn.path_info, "/"}"
        {:ok, conn}
      end

      defp call_controller_action(Plug.Conn[state: :unset] = conn, controller, action, binding) do
        {status, conn} = apply(controller, action, [conn, Keyword.delete(binding, :conn)])
        Sugar.App.log :debug, "#{conn.method} #{conn.status} /#{Enum.join conn.path_info, "/"}"
        {status, conn}
      end
      defp call_controller_action(conn, _, _, _) do
        {:ok, conn}
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

  defmacro resource(route, controller) do
    quote do
      get     unquote(route),                unquote(controller), :index
      get     unquote(route) <> "/new",      unquote(controller), :new
      post    unquote(route),                unquote(controller), :create
      get     unquote(route) <> "/:id",      unquote(controller), :show
      get     unquote(route) <> "/:id/edit", unquote(controller), :edit
      put     unquote(route) <> "/:id",      unquote(controller), :update
      patch   unquote(route) <> "/:id",      unquote(controller), :patch
      delete  unquote(route) <> "/:id",      unquote(controller), :delete

      options unquote(route) do
        {:ok, var!(conn) |> resp(200, "") |> put_resp_header("Allow", "HEAD,GET,POST") |> send_resp}
      end
      options unquote(route <> "/new") do
        {:ok, var!(conn) |> resp(200, "") |> put_resp_header("Allow", "HEAD,GET") |> send_resp}
      end
      options unquote(route <> "/:_id") do
        {:ok, var!(conn) |> resp(200, "") |> put_resp_header("Allow", "HEAD,GET,PUT,PATCH,DELETE") |> send_resp}
      end
      options unquote(route <> "/:_id/edit") do
        {:ok, var!(conn) |> resp(200, "") |> put_resp_header("Allow", "HEAD,GET") |> send_resp}
      end
    end
  end

  defp build_match(controller, action) do
    quote do 
      binding = binding()

      # only continue if we receive :ok from middleware
      {:ok, conn} = apply_middleware var!(conn)

      # pass off to controller action
      call_controller_action conn, unquote(controller), unquote(action), binding
    end
  end
end
