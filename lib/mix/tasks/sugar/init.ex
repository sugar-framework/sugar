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

  defp do_init(_opts) do
    name = camelize atom_to_binary(Mix.project[:app])

    assigns = [
      app: Mix.project[:app], 
      module: name
    ]
    
    # Priviliged
    create_directory "priv"
    create_directory "priv/static"

    # Support files
    Mix.Tasks.Sugar.Gen.Config.run_detached assigns
    Mix.Tasks.Sugar.Gen.Router.run_detached assigns

    # Controllers
    create_directory "lib/#{underscore name}/controllers"
    Mix.Tasks.Sugar.Gen.Controller.run_detached(assigns ++ [name: "main"])
    
    # Models
    Mix.Tasks.Ecto.Gen.Repo.run ["#{name}.Repos.Main"]
    create_directory "priv/main"
    create_directory "lib/#{underscore name}/models"
    create_directory "lib/#{underscore name}/queries"
    
    # Views
    create_directory "lib/#{underscore name}/views"
    Mix.Tasks.Sugar.Gen.View.run_detached(assigns ++ [name: "main/index"])

  end
end