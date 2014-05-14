defmodule Mix.Tasks.Sugar.Gen.ControllerTest do
  use ExUnit.Case, async: true

  test "run_detached/1" do
    assigns = [
      app: :test_app,
      module: "TestApp",
      path: "test/fixtures"
    ]
    Mix.Tasks.Sugar.Gen.Controller.run_detached(assigns ++ [name: "main"])

    assert File.exists?("test/fixtures/controllers/main.ex") === true
    File.rm_rf! "test/fixtures/controllers"
  end

  test "run/1 with proper name" do
    args = ["main", "--path=test/fixtures"]
    Mix.Tasks.Sugar.Gen.Controller.run(args)

    assert File.exists?("test/fixtures/controllers/main.ex") === true
    File.rm_rf! "test/fixtures/controllers"
  end

  test "run/1 with no name" do
    args = ["--path=test/fixtures"]
    assert_raise Mix.Error, fn ->
      Mix.Tasks.Sugar.Gen.Controller.run(args)
    end
  end

  test "run/1 with improper name" do
    args = ["main/bad", "--path=test/fixtures"]
    assert_raise Mix.Error, fn ->
      Mix.Tasks.Sugar.Gen.Controller.run(args)
    end
  end
end
