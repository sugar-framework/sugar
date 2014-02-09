defmodule Sugar.Middleware do
  @moduledoc """
  
  """

  ## Macros

  @doc """
  Macro used to add necessary items to a router.
  """
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      Module.register_attribute __MODULE__, :plugs, accumulate: true
      @before_compile unquote(__MODULE__)
    end
  end

  @doc """
  Defines a default route to catch all unmatched routes.
  """
  defmacro __before_compile__(_env) do
    quote do
      def plugs do
        @plugs
      end

      def apply_middleware(conn) do
        Enum.reduce plugs, {:ok, conn}, fn
          plug, {:ok, c}    -> plug.call(c, [])
          plug, {:halt!, c} -> {:halt!, c}
        end
      end
    end
  end

  @doc """
  Macro for adding middleware. 

  Any middleware should follow `Plug` format, containing
  a definition of `call/2`.

  ## Arguments

  - `plug` - `Atom`

  ## Example

      defmodule Router do
        use Sugar.Router

        middleware Sugar.Middleware.Static

        get "/", Hello, :index
        get "/pages/:id", Hello, :show
        post "/pages", Hello, :create
        put "/pages/:id" when id == 1, Hello, :show
      end
  """
  defmacro middleware(plug) do
    quote do
      @plugs unquote(plug)
    end
  end
end