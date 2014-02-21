defmodule Mix.Tasks.Sugar.Gen.Model do
  use Mix.Task
  import Mix.Generator
  import Mix.Utils, only: [camelize: 1, underscore: 1]

  @shortdoc "Creates Sugar model files"
  @recursive true

  @moduledoc """
  """
  def run(args) do
    opts = OptionParser.parse(args)
    case elem(opts, 1) do
      [] -> raise Mix.Error, message: "expected MODULE_NAME to be given"
      [name|_] ->
        check_name! name
        do_create_files name, elem(opts, 0)
    end
  end

  def run_detached(assigns) do
    do_create_files assigns[:name], assigns
  end

  defp do_create_files(name, _opts) do
    module = camelize atom_to_binary(Mix.project[:app])

    assigns = [
      app: Mix.project[:app], 
      module: module,
      name: camelize(name),
      table_name: name
    ]

    Mix.Tasks.Ecto.Gen.Migration.run ["#{module}.Repos.Main", "create_#{name}"]
    create_file "lib/#{underscore module}/models/#{underscore name}.ex", model_template(assigns)
    create_file "lib/#{underscore module}/queries/#{underscore name}.ex", query_template(assigns)
  end

  embed_template :model, ~S"""
  defmodule <%= @module %>.Models.<%= @name %> do
    use Ecto.Model

    # Take a look at https://github.com/elixir-lang/ecto#models
    # for information about defining fields for your model.
    queryable "<%= @table_name %>" do
    end
  end
  """

  embed_template :query, ~S"""
  defmodule <%= @module %>.Queries.<%= @name %> do
    import Ecto.Query

    # Take a look at https://github.com/elixir-lang/ecto#query
    # for information about defining queries for your models.
    def all do
      query = from a in <%= @module %>.Models.<%= @name %>,
              select: a
      <%= @module %>.Repos.Main.all(query)
    end
  end
  """

  defp check_name!(name) do
    unless name =~ ~r/^[a-z][\w_]+$/ do
      raise Mix.Error, message: "model name must start with a letter and have only lowercase letters, numbers and underscore"
    end
  end
end