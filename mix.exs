defmodule Web.Mixfile do
  use Mix.Project

  def project do
    [ app: :sugar,
      elixir: "~> 0.12.3",
      version: "0.2.0-dev",
      name: "Sugar",
      source_url: "https://github.com/sugar-framework/sugar",
      deps: deps(Mix.env) ]
  end

  def application do
    [
      applications: [:cowboy, :plug, :exlager],
      mod: { Sugar.App, [] }
    ]
  end

  defp deps(:prod) do
    [
      { :mime, github: "dynamo/mime" },
      { :cowboy, github: "extend/cowboy" },
      { :plug, github: "elixir-lang/plug" },
      { :exlager, github: "khia/exlager" },
      { :jsex, github: "talentdeficit/jsex" },
      { :erlydtl, github: "erlydtl/erlydtl" },
      { :calliope, github: "nurugger07/calliope" },
      { :templates, github: "sugar-framework/templates" }
    ]
  end

  defp deps(:docs) do
    deps(:prod) ++
      [ 
        { :ex_doc, github: "elixir-lang/ex_doc" } 
      ]
  end

  defp deps(_) do
    deps(:prod) ++
      [ 
        { :hackney, github: "benoitc/hackney", tag: "0.10.1" } 
      ]
  end
end
