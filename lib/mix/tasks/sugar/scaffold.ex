defmodule Mix.Tasks.Sugar.Scaffold do
  use Mix.Task
  import Mix.Utils, only: [camelize: 1, underscore: 1]

  @shortdoc "Creates Sugar controller, model, and view files for a resource"
  @recursive true

  @moduledoc """
  """
  def run(args) do
    opts = OptionParser.parse(args)
    case elem(opts, 1) do
      [] -> raise Mix.Error, message: "expected RESOURCE_NAME to be given"
      [name|_] ->
        check_name! name
        do_scaffold name, elem(opts, 0)
    end
  end

  defp do_scaffold(name, _opts) do
    module = camelize atom_to_binary(Mix.project[:app])

    assigns = [
      app: Mix.project[:app], 
      module: module,
      name: name
    ]

    Mix.Tasks.Sugar.Gen.Controller.run_detached assigns
    Mix.Tasks.Sugar.Gen.Model.run_detached assigns
    Mix.Tasks.Sugar.Gen.View.run_detached [name: name <> "/index"]
  end

  defp check_name!(name) do
    unless name =~ ~r/^[a-z][\w_]+$/ do
      raise Mix.Error, message: "model name must start with a letter and have only lowercase letters, numbers and underscore"
    end
  end
end