defmodule Sugar.Router.Hooks do
  @doc """
  Macro used to add necessary items to a router.
  """
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      @hooks []
      @all_hooks_key :__all_hooks__
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(env) do
    module = env.module
    hooks = Module.get_attribute(module, :hooks)

    quote do
      def call_action(action, conn, args) do
        conn = call_before_hooks(unquote(hooks), unquote(module), action, conn)
        conn = apply(unquote(module), action, [conn, args])
        call_after_hooks(unquote(hooks), unquote(module), action, conn)
      end
    end
  end

  def call_before_hooks(hooks, module, action, conn) do
    call_hooks(:before, hooks, module, action, conn)
  end

  def call_after_hooks(hooks, module, action, conn) do
    call_hooks(:after, hooks, module, action, conn)
  end

  defp call_hooks(type, hooks, module, action, conn) do
    hooks
      |> Enum.filter(fn ({t, _}) -> t === type end)
      |> Enum.filter(fn ({_, {act, _}}) -> act === action || act === :__all_hooks__ end)
      |> Enum.reduce(conn, fn({_, {_, fun}}, conn) ->
        apply module, fun, [conn]
      end)
  end

  defmacro before_hook(function) when is_atom(function) do
    quote do
      @hooks @hooks++[{:before, {@all_hooks_key, unquote(function)}}]
    end
  end
  defmacro before_hook(function, _opts) when is_atom(function) do
    quote do
    end
  end

  defmacro after_hook(function) when is_atom(function) do
    quote do
      @hooks @hooks++[{:after, {@all_hooks_key, unquote(function)}}]
    end
  end
  defmacro after_hook(function, _opts) when is_atom(function) do
    quote do
    end
  end
end
