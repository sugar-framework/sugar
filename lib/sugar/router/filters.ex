defmodule Sugar.Router.Filters do
  @moduledoc """
  Allows for before and after hooks to a controller. Each hook has the
  opportunity to modify and/or read the request's `conn` in each stage.

  #### Example

      defmodule Router do
        use Sugar.Router
        alias Filters

        before_filter Filters, :set_json
        after_filter Filters, :clear_assigns

        # routes
        # ...
      end

      defmodule Filters do
        import Plug.Conn

        def set_json(conn) do
          conn |> put_resp_header("content-type", "application/json; charset=utf-8")
        end

        def clear_assigns(conn) do
          %{ conn | assigns: %{} }
        end
      end
  """

  @doc """
  Macro used to add necessary items to a router.
  """
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      @filters []
      @all_filters_key :__all_filters__
      @before_compile unquote(Sugar.Router)
    end
  end

  @doc false
  def call_before_filters(filters, action, conn) do
    call_filters(:before, filters, action, conn)
  end

  @doc false
  def call_after_filters(filters, action, conn) do
    call_filters(:after, filters, action, conn)
  end

  defp call_filters(type, filters, action, conn) do
    filters
      |> Enum.filter(fn ({t, _}) -> t === type end)
      |> Enum.filter(fn ({_, {act, _}}) -> act === action || act === :__all_filters__ end)
      |> Enum.reduce(conn, fn({_, {_, {module, fun}}}, conn) ->
        apply module, fun, [conn]
      end)
  end

  @doc """
  Adds a before hook to a controller.

  ## Arguments

  * `module` - `atom` - name of the module that contains the filter function
  * `function` - `atom` - name of the function to be called within the hook
  """
  defmacro before_filter(module, function) do
    quote do
      @filters @filters++[{:before, {@all_filters_key, {unquote(module), unquote(function)}}}]
    end
  end

  @doc """
  Adds a after hook to a controller.

  ## Arguments

  * `module` - `atom` - name of the module that contains the filter function
  * `function` - `atom` - name of the function to be called within the hook
  """
  defmacro after_filter(module, function) do
    quote do
      @filters @filters++[{:after, {@all_filters_key, {unquote(module), unquote(function)}}}]
    end
  end
end
