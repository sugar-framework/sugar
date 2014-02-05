defmodule Sugar.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Sugar.Router

  test "the truth" do
    assert true
  end

  defmodule Foo do
    use Sugar.Controller
    def bar(conn) do
      conn
        |> put_resp_content_type("text/html")
        |> resp 200, "hello world"
    end
  end
end
