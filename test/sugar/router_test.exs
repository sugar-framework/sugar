defmodule Sugar.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "the truth" do
    assert true
  end

  defmodule Foo do
    use Sugar.Controller
    def bar(conn) do
      render conn, ""
    end
  end

  defmodule Router do
    use Sugar.Router

    get "/", Foo, :bar
  end
end
