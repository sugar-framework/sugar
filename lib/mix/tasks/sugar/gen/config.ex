defmodule Mix.Tasks.Sugar.Gen.Config do
  use Mix.Task
  import Mix.Generator
  import Mix.Utils, only: [camelize: 1, underscore: 1]

  @shortdoc "Creates Sugar config files"
  @recursive true

  @moduledoc """
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

    create_file "#{assigns[:path]}/config.ex", config_template(assigns)
  end

  embed_template :config, ~S"""
  defmodule Config do
  def config do
    [
      log: false,
      server: [
        port: 4000
      ]
    ]
  end
end
  """
end
