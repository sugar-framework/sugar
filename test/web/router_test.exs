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
      {"GET", [""], Foo, :bar},
      {"GET", ["foo"], Foo, :bar}
    ]

    conn = conn('GET', "/no-match/route")
    refute match(conn, routes)

    conn = conn('GET', "/foo")
    assert match(conn, routes) === {Foo, :bar}
  end

  test "parse_routes/1" do
    routes = [
      [route: "/foo/bar", verb: :GET, controller: Foo, action: :bar]
    ]
    assert parse_routes(routes) === [{"GET", ["foo", "bar"], Foo, :bar}]
  end

  test "parse_route/1" do
    route = [route: "/foo/bar", verb: :GET, controller: Foo, action: :bar]
    assert parse_route(route) === {"GET", ["foo", "bar"], Foo, :bar}
  end

  defmodule Foo do
    use Web.Controller
    def bar(conn) do
      conn
        |> put_resp_content_type("text/html")
        |> resp 200, "hello world"
    end
  end
end
