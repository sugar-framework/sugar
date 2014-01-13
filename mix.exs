defmodule Web.Mixfile do
  use Mix.Project

  def project do
    [ app: :web,
      elixir: "~> 0.12.0",
      version: "0.1.0-dev",
      name: "Web",
      #source_url: "https://github.com/slogsdon/elixir-web",
      deps: deps(Mix.env) ]
  end

  def application do
    [
      applications: [:cowboy, :plug, :mimetypes, :exlager],
      mod: { Web.App, [] }
    ]
  end

  defp deps(:prod) do
    [
      { :mimetypes, github: "spawngrid/mimetypes", override: true },
      { :cowboy, github: "extend/cowboy" },
      { :plug, github: "elixir-lang/plug" },
      { :exlager, github: "khia/exlager" }
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
