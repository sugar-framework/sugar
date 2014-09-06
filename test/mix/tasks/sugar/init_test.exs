defmodule Mix.Tasks.Sugar.InitTest do
  use ExUnit.Case, async: true

  test "mix project can be altered" do
    args = [
      "my_test_app",
      "--path=test/fixtures/my_test_app",
      "--priv-path=test/fixtures/my_test_app/priv",
      "--no-repo"
    ]
    Mix.Tasks.Sugar.Init.run args

    # Priviliged
    assert File.exists?("test/fixtures/my_test_app/priv") === true
    assert File.exists?("test/fixtures/my_test_app/priv/static") === true

    # Support files
    assert File.exists?("test/fixtures/my_test_app/config.ex") === true
    assert File.exists?("test/fixtures/my_test_app/router.ex") === true

    # Controllers
    assert File.exists?("test/fixtures/my_test_app/controllers") === true
    assert File.exists?("test/fixtures/my_test_app/controllers/main.ex") === true

    # Models
    assert File.exists?("test/fixtures/my_test_app/priv/main") === true
    assert File.exists?("test/fixtures/my_test_app/models") === true
    assert File.exists?("test/fixtures/my_test_app/queries") === true

    # Views
    assert File.exists?("test/fixtures/my_test_app/views") === true
    assert File.exists?("test/fixtures/my_test_app/views/main/index.html.eex") === true

    File.rm_rf "test/fixtures/my_test_app"
  end
end
