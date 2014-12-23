defmodule Sugar.Router.UtilTest do
  use ExUnit.Case, async: true
  import Sugar.Router.Util

  test "split/1" do
    assert split("bin/sh")    === ["bin", "sh"]
    assert split("bin/:sh")   === ["bin", ":sh"]
    assert split("bin/*sh")   === ["bin", "*sh"]
    assert split("/bin/sh")   === ["bin", "sh"]
    assert split("//bin/sh/") === ["bin", "sh"]
  end

  test "build_spec/2 proper" do
    assert build_spec("bin/:sh", nil) === {[:sh], ["bin", {:sh, [], nil}]}
    assert build_spec("bin/*sh", nil) === {[:sh], [{:|, [], ["bin", {:sh, [], nil}]}]}
    assert build_spec("*sh", nil)     === {[:sh], {:sh, [], nil}}
  end

  test "build_spec/2 illegal chars" do
    message = "identifier in routes must be made of letters, numbers and underscore"
    assert_raise Sugar.Router.Util.InvalidSpecError, ":" <> message, fn ->
      build_spec("bin/:sh-", nil)
    end

    assert_raise Sugar.Router.Util.InvalidSpecError, "*" <> message, fn ->
      build_spec("bin/*sh-", nil)
    end
  end

  test "build_spec/2 bad name" do
    message = "in routes must be followed by lowercase letters"
    assert_raise Sugar.Router.Util.InvalidSpecError, ": " <> message, fn ->
      build_spec("bin/:-sh", nil)
    end

    assert_raise Sugar.Router.Util.InvalidSpecError, "* " <> message, fn ->
      build_spec("bin/*-sh", nil)
    end
  end

  test "build_spec/2 glob with segments after capture" do
    message = "cannot have a *glob followed by other segments"
    assert_raise Sugar.Router.Util.InvalidSpecError, message, fn ->
      build_spec("bin/*sh/json", nil)
    end
  end
end