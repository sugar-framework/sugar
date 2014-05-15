defmodule Web.Mixfile do
  use Mix.Project

  def project do
    [ app: :sugar,
      elixir: "~> 0.13.2",
      version: "0.3.0",
      name: "Sugar",
      deps: deps(Mix.env),
      package: package,
      description: description,
      docs: [readme: true, main: "README"],
      test_coverage: [tool: ExCoveralls] ]
  end

  def application do
    [ applications: [:cowboy, :plug],
      mod: { Sugar.App, [] } ]
  end

  defp deps(:prod) do
    [ { :cowboy, "~> 0.9", github: "extend/cowboy" },
      { :plug, "0.4.3" },
      { :jsex, "2.0.0" },
      { :ecto, "0.1.0" },
      { :postgrex, "0.5.0" },
      { :plugs, "~> 0.0.2-dev", github: "sugar-framework/plugs" } ]
  end

  defp deps(:docs) do
    deps(:prod) ++
      [ { :ex_doc, github: "elixir-lang/ex_doc" } ]
  end

  defp deps(_) do
    deps(:prod) ++
      [ { :hackney, github: "benoitc/hackney" },
        { :excoveralls, "0.2.0" } ]
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
