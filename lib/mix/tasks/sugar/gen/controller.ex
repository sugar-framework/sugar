defmodule Mix.Tasks.Sugar.Gen.Controller do
  use Mix.Task
  import Mix.Generator
  import Macro, only: [camelize: 1, underscore: 1]

  @shortdoc "Creates Sugar controller files"
  @recursive true

  @moduledoc """
  Creates Sugar controller files.

  ## Command line options

  * `--path` - override the project path. Defaults to `lib/[app name]`

  """
  def run(args) do
    opts = OptionParser.parse(args)
    case elem(opts, 1) do
      [] -> raise Mix.Error, message: "expected CONTROLLER_NAME to be given"
      [name|_] ->
        check_name! name
        do_create_file name, elem(opts, 0)
    end
  end

  def run_detached(assigns) do
    do_create_file assigns[:name], assigns
  end

  defp do_create_file(name, opts) do
    module = camelize String.Chars.to_string(Mix.Project.config[:app])
    name = camelize name
    path = "lib/#{underscore name}"

    assigns = [
      app: Mix.Project.config[:app],
      module: module,
      name: name,
      path: path
    ] |> Keyword.merge(opts)
    assigns = assigns |> Keyword.merge([name: camelize(assigns[:name])])

    create_file "#{assigns[:path]}/controllers/#{underscore name}.ex", controller_template(assigns)
  end

  embed_template :controller, ~S"""
  defmodule <%= @module %>.Controllers.<%= @name %> do
    use Sugar.Controller

    def index(conn, []) do
      raw conn |> resp(200, "Hello world")
    end
  end
  """

  defp check_name!(name) do
    unless name =~ ~r/^[a-z][\w_]+$/ do
      raise Mix.Error, message: "controller name must start with a letter and have only lowercase letters, numbers and underscore"
    end
  end
end
