defmodule Mix.Tasks.Sugar.Scaffold do
  use Mix.Task
  import Macro, only: [camelize: 1, underscore: 1]

  @shortdoc "Creates Sugar controller, model, and view files for a resource"
  @recursive true

  @moduledoc """
  Creates Sugar controller, model (+ queries and migration), and view
  files for a resource.

  ## Command line options

  * `--path` - override the project path. Defaults to `lib/[app name]`
  * `--priv_path` - override the priv path. Defaults to `priv`

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

  defp do_scaffold(name, opts) do
    path = "lib/#{underscore name}"
    assigns = [
      app: Mix.Project.config[:app],
      module: name,
      path: path,
      priv_path: "priv"
    ] |> Keyword.merge(opts)

    Mix.Tasks.Sugar.Gen.Controller.run_detached([name: name] ++ assigns)
    Mix.Tasks.Sugar.Gen.View.run_detached([name: name <> "/index"] ++ assigns)
  end

  defp check_name!(name) do
    unless name =~ ~r/^[a-z][\w_]+$/ do
      raise Mix.Error, message: "resource name must start with a letter and have only lowercase letters, numbers and underscore"
    end
  end
end
