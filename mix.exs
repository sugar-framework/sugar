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

  # Configuration for the OTP application
  def application do
    [
      applications: [:cowboy, :plug, :mimetypes, :exlager],
      mod: { Web.App, [] }
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
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
