defmodule Mix.Tasks.Sugar.Gen.RouterTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  test "run_detached/1" do
    assigns = [
      app: :test_app,
      module: "TestApp",
      path: "test/fixtures"
    ]
    capture_io(fn ->
      Mix.Tasks.Sugar.Gen.Router.run_detached(assigns)
    end)
    expected_path = "test/fixtures/router.ex"

    assert File.exists?(expected_path) === true
    File.rm! expected_path
  end

  test "run/1" do
    args = ["--path=test/fixtures"]
    capture_io(fn ->
      Mix.Tasks.Sugar.Gen.Router.run(args)
    end)
    expected_path = "test/fixtures/router.ex"

    assert File.exists?(expected_path) === true
    File.rm! expected_path
  end
end
