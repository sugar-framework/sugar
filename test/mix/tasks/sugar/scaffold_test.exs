defmodule Mix.Tasks.Sugar.ScaffoldTest do
  use ExUnit.Case

  test "run/1 with proper name" do
    args = ["main", "--path=test/fixtures", "--module=Mix.Tasks.Sugar.ScaffoldTest"]
    Mix.Tasks.Sugar.Scaffold.run(args)

    assert File.exists?("test/fixtures/controllers/main.ex") === true
    assert File.exists?("test/fixtures/views/main/index.html.eex") === true
    assert File.exists?("test/fixtures/models/main.ex") === true
    assert File.exists?("test/fixtures/queries/main.ex") === true

    File.rm_rf! "test/fixtures/controllers"
    File.rm_rf! "test/fixtures/models"
    File.rm_rf! "test/fixtures/queries"
    File.rm_rf! "test/fixtures/repo"
    File.rm_rf! "test/fixtures/views"
  end

  test "run/1 with no name" do
    args = ["--path=test/fixtures"]
    assert_raise Mix.Error, fn ->
      Mix.Tasks.Sugar.Scaffold.run(args)
    end
  end

  test "run/1 with improper name" do
    args = ["main/bad", "--path=test/fixtures"]
    assert_raise Mix.Error, fn ->
      Mix.Tasks.Sugar.Scaffold.run(args)
    end
  end

  defmodule Repos.Main do
    use Ecto.Repo, adapter: Ecto.Adapters.Postgres, env: Mix.env

    @doc "Adapter configuration"
    def conf(_env), do: parse_url url

    def url do
      "ecto://"
    end

    def priv do
      "test/fixtures/repo"
    end
  end
end
