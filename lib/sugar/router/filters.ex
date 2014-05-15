defmodule Sugar.Router.Filters do
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

  def call_before_filters(filters, action, conn) do
    call_filters(:before, filters, action, conn)
  end

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

  defmacro before_filter(module, function) do
    quote do
      @filters @filters++[{:before, {@all_filters_key, {unquote(module), unquote(function)}}}]
    end
  end

  defmacro after_filter(module, function) do
    quote do
      @filters @filters++[{:after, {@all_filters_key, {unquote(module), unquote(function)}}}]
    end
  end
end
