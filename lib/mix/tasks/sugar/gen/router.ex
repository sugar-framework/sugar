defmodule Mix.Tasks.Sugar.Gen.Router do
  use Mix.Task
  import Mix.Generator
  import Mix.Utils, only: [camelize: 1, underscore: 1]

  @shortdoc "Creates Sugar router files"
  @recursive true

  @moduledoc """
  Creates Sugar router files.

  ## Command line options

  * `--path` - override the project path. Defaults to `lib/[app name]`

  """
  def run(args) do
    opts = OptionParser.parse(args)
    do_create_file elem(opts, 0)
  end

  def run_detached(assigns) do
    do_create_file assigns
  end

  defp do_create_file(opts) do
    module = camelize atom_to_binary(Mix.project[:app])

    assigns = [
      app: Mix.project[:app],
      module: module,
      path: "lib/#{underscore module}"
    ] |> Keyword.merge opts

    create_file "#{assigns[:path]}/router.ex", router_template(assigns)
  end

  embed_template :router, ~S"""
  defmodule Router do
    use Sugar.Router, plugs: [
        { Plugs.HotCodeReload, [] },
        { Plug.Static, at: "/static", from: :<%= @app %> },

        # Uncomment the following line for session store
        # { Plug.Session, store: :ets, key: "sid", secure: true, table: :session },

        # Uncomment the following line for request logging,
        # and add 'applications: [:exlager],' to the application
        # Keyword list in your mix.exs
        # { Plugs.Logger, [] }
    ]

    # Define your routes here
    get "/", <%= @module %>.Controllers.Main, :index
  end
  """
end
