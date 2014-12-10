defmodule Sugar.Mixfile do
  use Mix.Project

  def project do
    [ app: :sugar,
      elixir: "~> 1.0",
      version: "0.4.0-dev",
      name: "Sugar",
      deps: deps(Mix.env),
      package: package,
      description: description,
      docs: [readme: true, main: "README"],
      test_coverage: [tool: ExCoveralls] ]
  end

  def application do
    [ applications: [:cowboy, :plug, :templates],
      mod: { Sugar.App, [] } ]
  end

  defp deps(:prod) do
    [ { :cowboy, "~> 1.0.0" },
      { :plug, "~> 0.7.0" },
      { :jsex, "~> 2.0.0" },
      { :ecto, "~> 0.2.5" },
      { :postgrex, "~> 0.6.0" },
      { :plugs, github: "sugar-framework/plugs" },
      { :templates, github: "sugar-framework/templates" } ]
  end

  defp deps(:docs) do
    deps(:prod) ++
      [ { :ex_doc, github: "elixir-lang/ex_doc" } ]
  end

  defp deps(_) do
    deps(:prod) ++
      [ { :hackney, github: "benoitc/hackney" },
        { :excoveralls, "~> 0.3" } ]
  end

  defp description do
    """
    Modular web framework
    """
  end

  defp package do
    %{contributors: ["Shane Logsdon"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/sugar-framework/sugar",
               "Docs" => "http://sugar-framework.github.io/docs/"}}
  end
end
