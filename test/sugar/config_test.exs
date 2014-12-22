defmodule Sugar.ConfigTest do
  use ExUnit.Case, async: true
  import Sugar.Config

  test "get/1" do
    assert get(:router) === nil
  end

  test "get/2" do
    assert get(Router, :https_only) === nil
    assert get(:sugar, :views_dir)
  end

  test "get/3" do
    assert get(:sugar, :router, Router) === Router
    assert get(Router, :https_only, false) === false
  end
end
