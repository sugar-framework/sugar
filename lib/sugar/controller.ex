defmodule Sugar.Controller do
  @moduledoc """
  Controllers facilitate some separation of concerns for your application's logic.

  All handler actions should have an arrity of 2, with the first argument being
  a `Plug.Conn` representing the current connection and the second argument
  being a `Keyword` list of any parameters captured in the route path.

  `Sugar.Controller` imports `Plug.Conn`, the `plug/1` and `plug/2` macros from
  `Plug.Builder`, `Sugar.Controller`, and `Sugar.Controller.Helpers` for
  convenience when creating handlers for your applications

  ## Example

      defmodule Controllers.Pages do
        use Sugar.Controller

        @doc false
        def index(conn, []) do
          # Somehow get our content
          pages = Queries.Page.all
          render conn, pages
        end

        @doc false
        def show(conn, args) do
          result = case Integer.parse args["page_id"] do
              :error ->
                %Error{ id: "no_page_id",
                        message: "A valid page_id is required." }
              {i, _} ->
                Queries.Page.get i
            end

          render conn, result
        end

        @doc false
        def create(conn, args) do
          render conn, Queries.Page.create args, status: :created
        end

        @doc false
        def update(conn, args) do
          result = case Integer.parse args["page_id"] do
              :error ->
                %Error{ id: "no_page_id",
                        message: "A valid page_id is requried." }
              {i, _} ->
                Queries.Page.update i, args
            end

          render conn, result
        end
      end
  """

  @doc false
  defmacro __using__(_) do
    quote do
      import Plug.Conn
      import Plug.Builder, only: [plug: 1, plug: 2]
      import Sugar.Controller
      import Sugar.Controller.Helpers
      @before_compile Sugar.Controller
      @behaviour Plug
      Module.register_attribute(__MODULE__, :plugs, accumulate: true)
    end
  end

  @doc false
  defmacro __before_compile__(env) do
    plugs = Module.get_attribute(env.module, :plugs)
            |> Enum.map(fn { plug, opts, guard } ->
              { plug, Keyword.put_new(opts, :run, :before), guard }
            end)

    plug_stacks = build_plug_stacks env, plugs

    quote do
      def init(opts) do
        opts
      end

      def call(conn, opts) do
        conn = do_call(conn, :before, opts[:action])
        conn = apply(__MODULE__, opts[:action], [ conn, opts[:args] ])
        do_call(conn, :after, opts[:action])
      end

      defoverridable [init: 1, call: 2]

      unquote(plug_stacks)
    end
  end

  defp build_plug_stacks(env, plugs) do
    only_actions = get_only_actions plugs

    Enum.map only_actions ++ [nil], fn action ->
      build_plug_stacks_for(action, env, plugs)
    end
  end

  defp build_plug_stacks_for(action, env, plugs) do
    before_body = build_calls_for(:before, action, env, plugs)
    after_body = build_calls_for(:after, action, env, plugs)

    quote do
      unquote(before_body)
      unquote(after_body)
    end
  end

  defp build_calls_for(before_or_after, nil, env, plugs) do
    plugs = plugs
              |> Enum.filter(fn { _, opts, _ } ->
                opts[:only] === nil
              end)
              |> Enum.filter(fn { _, opts, _ } ->
                opts[:run] === before_or_after
              end)
    { conn, body } = env |> Plug.Builder.compile(plugs, [])

    quote do
      defp do_call(unquote(conn), unquote(before_or_after), _) do
        unquote(body)
      end
    end
  end
  defp build_calls_for(before_or_after, action, env, plugs) do
    plugs = plugs
              |> Enum.filter(fn { _, opts, _ } ->
                opts[:only] === nil ||
                action === opts[:only] ||
                action in opts[:only]
              end)
              |> Enum.filter(fn { _, opts, _ } ->
                opts[:run] === before_or_after
              end)
    { conn, body } = env |> Plug.Builder.compile(plugs, [])

    quote do
      defp do_call(unquote(conn), unquote(before_or_after), unquote(action)) do
        unquote(body)
      end
    end
  end

  defp get_only_actions(plugs) do
    plugs
      |> Enum.filter(fn { _, opts, _ } ->
        opts[:only] != nil
      end)
      |> Enum.flat_map(fn { _, opts, _ } ->
        opts[:only]
      end)
      |> Enum.uniq
  end
end
