defmodule Web.ControllerTest do
  use ExUnit.Case, async: true

  test "__using__/1" do
    use Web.Controller
    assert Keyword.has_key? __ENV__.functions, Plug.Connection
  end
end
