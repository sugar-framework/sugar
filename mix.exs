defmodule Sugar.Mixfile do
  use Mix.Project

  def project do
    [ app: :sugar,
      elixir: "~> 1.0",
      version: "0.4.9",
      name: "Sugar",
      source_url: "https://github.com/sugar-framework/sugar",
      homepage_url: "https://sugar-framework.github.io",
      deps: deps,
      package: package,
      description: description,
      docs: [readme: "README.md", main: "README"],
      test_coverage: [tool: ExCoveralls] ]
  end

  def application do
    [ applications: [ :cowboy, :plug, :templates, :poison, :ecto,
                      :postgrex, :plugs ],
      mod: { Sugar.App, [] } ]
  end

  defp deps do
    [ { :cowboy, "~> 1.0.2" },
      { :plug, "~> 0.14.0" },
      { :http_router, "~> 0.0.7" },
      { :poison, "~> 1.4.0" },
      { :ecto, "~> 0.15.0" },
      { :postgrex, "~> 0.9.1" },
      { :plugs, "~> 0.0.4" },
      { :templates, "~> 0.0.5" },
      { :earmark, "~> 0.1.17", only: :docs },
      { :ex_doc, "~> 0.8.0", only: :docs },
      { :excoveralls, "~> 0.3.11", only: :test },
      { :dialyze, "~> 0.2.0", only: :test } ]
  end

  defp description do
    """
    Modular web framework
    """
  end

  defp package do
    %{contributors: ["Shane Logsdon", "Ryan S. Northrup"],
      files: ["lib",  "mix.exs", "README.md", "LICENSE"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/sugar-framework/sugar",
               "Docs" => "https://sugar-framework.github.io/docs/"}}
  end
end
