defmodule Mix.Tasks.Sugar.InitTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  test "mix project can be altered" do
    args = [
      "my_test_app",
      "--path=test/fixtures/my_test_app",
      "--priv-path=test/fixtures/my_test_app/priv",
      "--no-repo"
    ]
    capture_io(fn ->
      Mix.Tasks.Sugar.Init.run args
    end)

    # Priviliged
    assert File.exists?("test/fixtures/my_test_app/priv") === true
    assert File.exists?("test/fixtures/my_test_app/priv/static") === true

    # Support files
    assert File.exists?("test/fixtures/my_test_app/router.ex") === true

    # Controllers
    assert File.exists?("test/fixtures/my_test_app/controllers") === true
    assert File.exists?("test/fixtures/my_test_app/controllers/main.ex") === true

    # Views
    assert File.exists?("test/fixtures/my_test_app/views") === true
    assert File.exists?("test/fixtures/my_test_app/views/main/index.html.eex") === true

    File.rm_rf "test/fixtures/my_test_app"
  end

  test "mix project with repo can be altered" do
    args = [
      "my_test_app",
      "--path=test/fixtures/my_test_app",
      "--priv-path=test/fixtures/my_test_app/priv"
    ]
    capture_io(fn ->
      Mix.Tasks.Sugar.Init.run args
    end)

    # Priviliged
    assert File.exists?("test/fixtures/my_test_app/priv") === true
    assert File.exists?("test/fixtures/my_test_app/priv/static") === true

    # Support files
    assert File.exists?("test/fixtures/my_test_app/router.ex") === true

    # Controllers
    assert File.exists?("test/fixtures/my_test_app/controllers") === true
    assert File.exists?("test/fixtures/my_test_app/controllers/main.ex") === true

    # Views
    assert File.exists?("test/fixtures/my_test_app/views") === true
    assert File.exists?("test/fixtures/my_test_app/views/main/index.html.eex") === true

    File.rm_rf "test/fixtures/my_test_app"
    File.rm_rf "lib/sugar/repos"
  end
end
