defmodule Sugar.Controller.Hooks do
  @moduledoc """
  Allows for before and after hooks to a controller. Each hook has the
  opportunity to modify and/or read the request's `conn` in each stage.

  #### Example

      defmodule MyController do
        use Sugar.Controller

        before_hook :set_headers
        after_hook :send

        def index(conn, _args) do
          conn |> resp(200, "[]")
        end

        ## Hooks

        def set_headers(conn) do
          conn |> put_resp_header("content-type", "application/json; charset=utf-8")
        end

        def send(conn) do
          conn |> send_resp
        end
      end
  """

  @doc """
  Macro used to add necessary items to a controller.
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

      defp call_before_hooks(hooks, module, action, conn) do
        call_hooks(:before, hooks, module, action, conn)
      end

      defp call_after_hooks(hooks, module, action, conn) do
        call_hooks(:after, hooks, module, action, conn)
      end

      defp call_hooks(type, hooks, module, action, conn) do
        hooks
          |> Stream.filter(fn ({t, _}) -> t === type end)
          |> Stream.filter(fn ({_, {act, _}}) -> act === action || act === :__all_hooks__ end)
          |> Enum.reduce(conn, fn({_, {_, fun}}, conn) ->
            apply module, fun, [conn]
          end)
      end
    end
  end

  @doc """
  Adds a before hook to a controller.

  ## Arguments

  * `function` - `atom` - name of the function to be called within the hook
  * `opts` - `Keyword` - optional - used to target specific actions. Possible
    options include:
      * `only` - `List` - a list of atoms representing the actions on which the
        hook should be applied
  """
  defmacro before_hook(function) when is_atom(function) do
    quote do
      @hooks @hooks++[{:before, {@all_hooks_key, unquote(function)}}]
    end
  end
  defmacro before_hook(function, opts) when is_atom(function) do
    quote do
      opts = unquote(opts)
      function = unquote(function)
      cond do
        opts[:only] ->
          @hooks Enum.reduce(opts[:only], @hooks, fn (method, acc) ->
            acc++[{:before, {method, function}}]
          end)
        true ->
          @hooks
      end
    end
  end

  @doc """
  Adds an after hook to a controller.

  ## Arguments

  * `function` - `atom` - name of the function to be called within the hook
  * `opts` - `Keyword` - optional - used to target specific actions. Possible
    options include:
      * `only` - `List` - a list of atoms representing the actions on which the
        hook should be applied
  """
  defmacro after_hook(function) when is_atom(function) do
    quote do
      @hooks @hooks++[{:after, {@all_hooks_key, unquote(function)}}]
    end
  end
  defmacro after_hook(function, opts) when is_atom(function) do
    quote do
      opts = unquote(opts)
      function = unquote(function)
      cond do
        opts[:only] ->
          @hooks Enum.reduce(opts[:only], @hooks, fn (method, acc) ->
            acc++[{:after, {method, function}}]
          end)
        true ->
          @hooks
      end
    end
  end
end
