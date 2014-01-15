defmodule Sugar.AppTest do
  use ExUnit.Case, async: true
  import Sugar.App

  test "get_port/1" do
    assert get_port([]) === 4000
    assert get_port([port: 8888]) === 8888
    assert get_port([port: -8888]) === 8888
    assert get_port([port: "8888"]) === 8888
    assert get_port([port: "not-a-number"]) === 4000
  end
end
