defmodule Mix.Tasks.Sugar.ScaffoldTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  Application.put_env(:sugar, Mix.Tasks.Sugar.ScaffoldTest.Repos.Main, [])

  test "run/1 with proper name" do
    args = ["main", "--path=test/fixtures", "--module=Mix.Tasks.Sugar.ScaffoldTest"]
    capture_io(fn ->
      Mix.Tasks.Sugar.Scaffold.run(args)
    end)

    assert File.exists?("test/fixtures/controllers/main.ex") === true
    assert File.exists?("test/fixtures/views/main/index.html.eex") === true

    File.rm_rf! "test/fixtures/controllers"
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
end
