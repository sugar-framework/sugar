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
    end
  end

  defmacro get(route, controller, action) do
    quote do
      get unquote(route), do: unquote(
        quote do 
          apply(unquote(controller), unquote(action), [var!(conn), binding()])
        end
      )
    end
  end

  defmacro post(route, controller, action) do
    quote do
      post unquote(route), do: unquote(
        quote do 
          apply(unquote(controller), unquote(action), [var!(conn), binding()])
        end
      )
    end
  end

  defmacro put(route, controller, action) do
    quote do
      put unquote(route), do: unquote(
        quote do 
          apply(unquote(controller), unquote(action), [var!(conn), binding()])
        end
      )
    end
  end

  defmacro patch(route, controller, action) do
    quote do
      patch unquote(route), do: unquote(
        quote do 
          apply(unquote(controller), unquote(action), [var!(conn), binding()])
        end
      )
    end
  end

  defmacro delete(route, controller, action) do
    quote do
      delete unquote(route), do: unquote(
        quote do 
          apply(unquote(controller), unquote(action), [var!(conn), binding()])
        end
      )
    end
  end

  defmacro options(route, controller, action) do
    quote do
      options unquote(route), do: unquote(
        quote do 
          apply(unquote(controller), unquote(action), [var!(conn), binding()])
        end
      )
    end
  end

  defmacro any(route, controller, action) do
    quote do
      match unquote(route), do: unquote(
        quote do 
          apply(unquote(controller), unquote(action), [var!(conn), binding()])
        end
      )
    end
  end
end
