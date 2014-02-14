defmodule Sugar.Router do
  @moduledoc """
  `Sugar.Router` defines an alternate format for `Plug.Router` 
  routing. Supports all HTTP methods that `Plug.Router` supports.

  Routes are defined with the form:

      method route [guard], controller, action

  `method` is `get`, `post`, `put`, `patch`, `delete`, or `options`, 
  each responsible for a single HTTP method. `method` can also be 
  `any`, which will match on all HTTP methods. `controller` is any 
  valid Elixir module name, and `action` is any valid function 
  defined in the `controller` module.

  ## Example

      defmodule Router do
        use Sugar.Router

        get "/", Hello, :index
        get "/pages/:id", Hello, :show
        post "/pages", Hello, :create
        put "/pages/:id" when id == 1, Hello, :show
      end
  """

  ## Macros
  
  @doc """
  Macro used to add necessary items to a router.
  """
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      import Plug.Connection
      use Plug.Router
      @before_compile unquote(__MODULE__)

      plug Plugs.HotCodeReload
      plug Plugs.StaticFiles, url: "/static", path: "priv/static"
      plug Plugs.Session, name: "_sugar_session", adapter: Plugs.Session.Adapters.Ets

      plug :match
      plug :dispatch
    end
  end

  @doc """
  Defines a default route to catch all unmatched routes.
  """
  defmacro __before_compile__(_env) do
    quote do
      Plug.Router.match _ do
        conn = var!(conn)
        Sugar.Controller.not_found conn
      end

      defp call_controller_action(Plug.Conn[state: :unset] = conn, controller, action, binding) do
        apply controller, action, [conn, Keyword.delete(binding, :conn)]
      end
      defp call_controller_action(conn, _, _, _) do
        conn
      end
    end
  end

  @doc """
  Macro for defining `GET` routes.

  ## Arguments

  - `route` - `String|List`
  - `controller` - `Atom`
  - `action` - `Atom`
  """
  defmacro get(route, controller, action) do
    quote do
      get unquote(route), do: unquote(
        build_match controller, action
      )
    end
  end

  @doc """
  Macro for defining `POST` routes.

  ## Arguments

  - `route` - `String|List`
  - `controller` - `Atom`
  - `action` - `Atom`
  """
  defmacro post(route, controller, action) do
    quote do
      post unquote(route), do: unquote(
        build_match controller, action
      )
    end
  end

  @doc """
  Macro for defining `PUT` routes.

  ## Arguments

  - `route` - `String|List`
  - `controller` - `Atom`
  - `action` - `Atom`
  """
  defmacro put(route, controller, action) do
    quote do
      put unquote(route), do: unquote(
        build_match controller, action
      )
    end
  end

  @doc """
  Macro for defining `PATCH` routes.

  ## Arguments

  - `route` - `String|List`
  - `controller` - `Atom`
  - `action` - `Atom`
  """
  defmacro patch(route, controller, action) do
    quote do
      patch unquote(route), do: unquote(
        build_match controller, action
      )
    end
  end

  @doc """
  Macro for defining `DELETE` routes.

  ## Arguments

  - `route` - `String|List`
  - `controller` - `Atom`
  - `action` - `Atom`
  """
  defmacro delete(route, controller, action) do
    quote do
      delete unquote(route), do: unquote(
        build_match controller, action
      )
    end
  end

  @doc """
  Macro for defining `OPTIONS` routes.

  ## Arguments

  - `route` - `String|List`
  - `controller` - `Atom`
  - `action` - `Atom`
  """
  defmacro options(route, controller, action) do
    quote do
      options unquote(route), do: unquote(
        build_match controller, action
      )
    end
  end

  @doc """
  Macro for defining routes that match on all HTTP methods.

  ## Arguments

  - `route` - `String|List`
  - `controller` - `Atom`
  - `action` - `Atom`
  """
  defmacro any(route, controller, action) do
    quote do
      match unquote(route), do: unquote(
        build_match controller, action
      )
    end
  end

  @doc """
  Creates RESTful resource endpoints for a route/controller
  combination.

  ## Example

      resource "/path", Controller

  expands to

      get     "/path",                Controller, :index
      get     "/path" <> "/new",      Controller, :new
      post    "/path",                Controller, :create
      get     "/path" <> "/:id",      Controller, :show
      get     "/path" <> "/:id/edit", Controller, :edit
      put     "/path" <> "/:id",      Controller, :update
      patch   "/path" <> "/:id",      Controller, :patch
      delete  "/path" <> "/:id",      Controller, :delete

      options "/path" do
        {:ok, var!(conn) |> resp(200, "") |> put_resp_header("Allow", "HEAD,GET,POST") |> send_resp}
      end
      options "/path" <> "/new" do
        {:ok, var!(conn) |> resp(200, "") |> put_resp_header("Allow", "HEAD,GET") |> send_resp}
      end
      options "/path" <> "/:_id" do
        {:ok, var!(conn) |> resp(200, "") |> put_resp_header("Allow", "HEAD,GET,PUT,PATCH,DELETE") |> send_resp}
      end
      options "/path" <> "/:_id/edit" do
        {:ok, var!(conn) |> resp(200, "") |> put_resp_header("Allow", "HEAD,GET") |> send_resp}
      end
  """
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
        conn = var!(conn)
        conn |> resp(200, "") |> put_resp_header("Allow", "HEAD,GET,POST") |> send_resp
      end
      options unquote(route <> "/new") do
        conn = var!(conn)
        conn |> resp(200, "") |> put_resp_header("Allow", "HEAD,GET") |> send_resp
      end
      options unquote(route <> "/:_id") do
        conn = var!(conn)
        conn |> resp(200, "") |> put_resp_header("Allow", "HEAD,GET,PUT,PATCH,DELETE") |> send_resp
      end
      options unquote(route <> "/:_id/edit") do
        conn = var!(conn)
        conn |> resp(200, "") |> put_resp_header("Allow", "HEAD,GET") |> send_resp
      end
    end
  end

  defp build_match(controller, action) do
    quote do 
      binding = binding()
      conn = var!(conn)

      # only continue if we receive :ok from middleware
      # {:ok, conn} = apply_middleware 

      # pass off to controller action
      call_controller_action conn, unquote(controller), unquote(action), binding
    end
  end
end
