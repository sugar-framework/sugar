defmodule Mix.Tasks.Sugar.Gen.ConfigTest do
  use ExUnit.Case, async: true

  test "run_detached/1" do
    assigns = [
      app: :test_app,
      module: "TestApp",
      path: "test/fixtures"
    ]
    Mix.Tasks.Sugar.Gen.Config.run_detached(assigns ++ [name: "main"])
    expected_path = "test/fixtures/config.ex"

    assert File.exists?(expected_path) === true
    File.rm! expected_path
  end

  test "run/1" do
    args = ["--path=test/fixtures"]
    Mix.Tasks.Sugar.Gen.Config.run(args)
    expected_path = "test/fixtures/config.ex"

    assert File.exists?(expected_path) === true
    File.rm! expected_path
  end
end
