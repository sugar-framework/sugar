defmodule Sugar.Mixfile do
  use Mix.Project

  def project do
    [ app: :sugar,
      elixir: "~> 1.0",
      version: "0.4.6",
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
    [ { :cowboy, "~> 1.0.0" },
      { :plug, "~> 0.9.0" },
      { :http_router, "~> 0.0.4" },
      { :poison, "~> 1.3.0" },
      { :ecto, "~> 0.7.1" },
      { :postgrex, "~> 0.7" },
      { :plugs, "~> 0.0.2" },
      { :templates, "~> 0.0.2" },
      { :earmark, "~> 0.1.12", only: :docs },
      { :ex_doc, "~> 0.6.2", only: :docs },
      { :excoveralls, "~> 0.3", only: :test },
      { :dialyze, "~> 0.1.3", only: :test } ]
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
