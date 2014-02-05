defmodule Sugar.ControllerTest do
  use ExUnit.Case, async: true

  test "__using__/1" do
    use Sugar.Controller
    assert Keyword.has_key? __ENV__.functions, Sugar.Controller
  end
end
