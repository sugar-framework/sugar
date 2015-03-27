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
    module = camelize String.Chars.to_string(Mix.Project.config[:app])
    path = "lib/#{underscore module}"

    assigns = [
      app: Mix.Project.config[:app],
      module: module,
      path: path
    ] |> Keyword.merge opts

    create_file "#{assigns[:path]}/router.ex", router_template(assigns)
  end

  embed_template :router, ~S"""
  defmodule <%= @module %>.Router do
    use Sugar.Router
    plug Sugar.Plugs.HotCodeReload

    if Sugar.Config.get(:sugar, :show_debugger, false) do
      plug Plug.Debugger, otp_app: :<%= @app %>
    end

    plug Plug.Static, at: "/static", from: :<%= @app %>

    # Uncomment the following line for session store
    # plug Plug.Session, store: :ets, key: "sid", secure: true, table: :session

    # Define your routes here
    get "/", <%= @module %>.Controllers.Main, :index
  end
  """
end
