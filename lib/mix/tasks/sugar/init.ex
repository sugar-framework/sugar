defmodule Mix.Tasks.Sugar.Init do
  use Mix.Task
  import Mix.Generator
  import Mix.Utils, only: [camelize: 1, underscore: 1]

  @shortdoc "Creates Sugar support files"
  @recursive true

  @moduledoc """
  """
  def run(args) do
    opts = OptionParser.parse(args)
    do_init elem(opts, 0)
  end

  defp do_init(opts) do
    name = camelize atom_to_binary(Mix.project[:app])

    assigns = [
      app: Mix.project[:app],
      module: name,
      path: "lib/#{underscore name}",
      priv_path: "priv"
    ] |> Keyword.merge opts

    # Priviliged
    create_directory "#{assigns[:priv_path]}"
    create_directory "#{assigns[:priv_path]}/static"

    # Support files
    Mix.Tasks.Sugar.Gen.Config.run_detached assigns
    Mix.Tasks.Sugar.Gen.Router.run_detached assigns

    # Controllers
    create_directory "#{assigns[:path]}/controllers"
    Mix.Tasks.Sugar.Gen.Controller.run_detached(assigns ++ [name: "main"])

    # Models
    unless assigns[:no_repo] do
      Mix.Tasks.Ecto.Gen.Repo.run ["#{underscore assigns[:module]}.Repos.Main"]
    end
    create_directory "#{assigns[:priv_path]}/main"
    create_directory "#{assigns[:path]}/models"
    create_directory "#{assigns[:path]}/queries"

    # Views
    create_directory "#{assigns[:path]}/views"
    Mix.Tasks.Sugar.Gen.View.run_detached(assigns ++ [name: "main/index"])
  end
end
