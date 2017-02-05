defmodule Mix.Tasks.Sugar.Gen.View do
  use Mix.Task
  import Mix.Generator
  import Macro, only: [camelize: 1, underscore: 1]

  @shortdoc "Creates Sugar view files"
  @recursive true

  @moduledoc """
  Creates Sugar view files.

  ## Command line options

  * `--type=(eex|haml)` - set type of view to generate. Defaults to `eex`
  * `--path` - override the project path. Defaults to `lib/[app name]`

  """
  def run(args) do
    opts = OptionParser.parse(args)
    case elem(opts, 1) do
      [] -> raise Mix.Error, message: "expected VIEW_NAME to be given"
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

    case opts[:type] do
      "haml" -> create_file "#{assigns[:path]}/views/#{underscore name}.html.haml", haml_template(assigns)
      _ -> create_file "#{assigns[:path]}/views/#{underscore name}.html.eex", eex_template(assigns)
    end
  end

  embed_template :eex, ~S"""
  <!doctype html>
  <html lang="en-US">
  <head>
    <title><%= @name %> - <%= @module %></title>
  </head>
  <body>
    Hello World
  </body>
  </html>
  """

  embed_template :haml, ~S"""
  !!! 5
  %html{lang: "en-US"}
    %head
      %title
        = name <> module
    %body
      Hello World
  """

  defp check_name!(name) do
    unless name =~ ~r/^[a-z][\w_]+$/ do
      raise Mix.Error, message: "view name must start with a letter and have only lowercase letters, numbers and underscore"
    end
  end
end
