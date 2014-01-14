defmodule Web.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Web.Router

  test "route/1" do
    conn = conn('GET', "/no-match/route")
    assert route(conn) === :no_match
  end

  test "match/2" do
    routes = [
      {"GET", [""], Hello, :index},
      {"GET", ["hello"], Hello, :index}
    ]

    conn = conn('GET', "/no-match/route")
    assert route(conn) === :no_match

    conn = conn('GET', "/hello")
    assert route(conn) === {:match, Hello, :index}
  end

  test "parse_routes/1" do
    assert false
  end

  test "parse_route/1" do
    assert false
  end

  defmodule Hello do
    use Web.Controller
    def index(conn) do
      conn
        |> put_resp_content_type("text/html")
        |> resp 200, "hello world"
    end
  end
end
