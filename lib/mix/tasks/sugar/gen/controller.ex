defmodule Mix.Tasks.Sugar.Gen.Controller do
  use Mix.Task
  import Mix.Generator
  import Mix.Utils, only: [camelize: 1, underscore: 1]

  @shortdoc "Creates Sugar controller files"
  @recursive true

  @moduledoc """
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

  defp do_create_file(name, _opts) do
    module = camelize atom_to_binary(Mix.project[:app])
    name = camelize name

    assigns = [
      app: Mix.project[:app], 
      module: module,
      name: name
    ]

    create_file "lib/#{underscore module}/controllers/#{underscore name}.ex", controller_template(assigns)
  end

  embed_template :controller, ~S"""
  defmodule <%= @module %>.Controllers.<%= @name %> do
    use Sugar.Controller

    def index(conn, []) do
      text conn, "Hello world"
    end
  end
  """

  defp check_name!(name) do
    unless name =~ ~r/^[a-z][\w_]+$/ do
      raise Mix.Error, message: "controller name must start with a letter and have only lowercase letters, numbers and underscore"
    end
  end
end