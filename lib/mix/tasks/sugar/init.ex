defmodule Mix.Tasks.Sugar.Init do
  use Mix.Task
  import Mix.Generator
  import Macro, only: [camelize: 1, underscore: 1]

  @shortdoc "Creates Sugar support files"
  @recursive true

  @moduledoc """
  Creates Sugar support files for new projects after adding Sugar as a
  project dependency.

  ## Command line options

  * `--path` - override the project path. Defaults to `lib/[app name]`
  * `--priv-path` - override the priv path. Defaults to `priv`
  * `--no-repo` - skip creation of Ecto Repo

  """
  def run(args) do
    opts = OptionParser.parse(args, switches: [no_repo: :boolean, path: :string, priv_path: :string])
    do_init elem(opts, 0)
  end

  defp do_init(opts) do
    name = camelize String.Chars.to_string(Mix.Project.config[:app])
    path = "lib/#{underscore name}"

    assigns = [
      app: Mix.Project.config[:app],
      module: name,
      path: path,
      priv_path: "priv"
    ] |> Keyword.merge(opts)

    # Priviliged
    create_directory "#{assigns[:priv_path]}"
    create_directory "#{assigns[:priv_path]}/static"

    # Support files
    Mix.Tasks.Sugar.Gen.Router.run_detached assigns

    # Controllers
    create_directory "#{assigns[:path]}/controllers"
    Mix.Tasks.Sugar.Gen.Controller.run_detached(assigns ++ [name: "main"])

    # Views
    create_directory "#{assigns[:path]}/views"
    Mix.Tasks.Sugar.Gen.View.run_detached(assigns ++ [name: "main/index"])
  end
end
