defmodule Sugar.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use Sugar.Router

  test "cast_http_port/1" do
    assert Sugar.Router.cast_http_port(4444) === 4444
    assert Sugar.Router.cast_http_port("4444") === 4444
    assert Sugar.Router.cast_http_port('4444') === 4444
    assert Sugar.Router.cast_http_port(nil) === 4000
  end

  test "cast_https_port/1" do
    assert Sugar.Router.cast_https_port(4444) === 4444
    assert Sugar.Router.cast_https_port("4444") === 4444
    assert Sugar.Router.cast_https_port('4444') === 4444
    assert Sugar.Router.cast_https_port(nil) === 8443
  end

  test "get/3" do
    conn = conn(:get, "/get")
      |> Sugar.RouterTest.Router.call([])

    assert conn.state === :sent
    assert conn.status === 200
  end

  test "post/3" do
    conn = conn(:post, "/post")
      |> Sugar.RouterTest.Router.call([])

    assert conn.state === :sent
    assert conn.status === 200
  end

  test "put/3" do
    conn = conn(:put, "/put")
      |> Sugar.RouterTest.Router.call([])

    assert conn.state === :sent
    assert conn.status === 200
  end

  test "patch/3" do
    conn = conn(:patch, "/patch")
      |> Sugar.RouterTest.Router.call([])

    assert conn.state === :sent
    assert conn.status === 200
  end

  test "delete/3" do
    conn = conn(:delete, "/delete")
      |> Sugar.RouterTest.Router.call([])

    assert conn.state === :sent
    assert conn.status === 200
  end

  test "options/3" do
    conn = conn(:options, "/options")
      |> Sugar.RouterTest.Router.call([])

    assert conn.state === :sent
    assert conn.status === 200
  end

  test "any/3 any" do
    conn = conn(:any, "/any")
      |> Sugar.RouterTest.Router.call([])

    assert conn.state === :sent
    assert conn.status === 200
  end

  test "any/3 get" do
    conn = conn(:get, "/any")
      |> Sugar.RouterTest.Router.call([])

    assert conn.state === :sent
    assert conn.status === 200
  end

  test "raw/4 trace" do
    conn = conn(:trace, "/trace")
      |> Sugar.RouterTest.Router.call([])

    assert conn.state === :sent
    assert conn.status === 200
  end

  test "resource/2" do
    assert true === true
  end

  test "resource/2 index" do
    conn = conn(:get, "/users")
      |> Sugar.RouterTest.Router.call([])

    assert conn.state === :sent
    assert conn.status === 200
  end

  test "resource/2 create" do
    conn = conn(:post, "/users")
      |> Sugar.RouterTest.Router.call([])

    assert conn.state === :sent
    assert conn.status === 200
  end

  test "resource/2 show" do
    conn = conn(:get, "/users/1")
      |> Sugar.RouterTest.Router.call([])

    assert conn.state === :sent
    assert conn.status === 200
  end

  test "resource/2 update" do
    conn = conn(:put, "/users/1")
      |> Sugar.RouterTest.Router.call([])

    assert conn.state === :sent
    assert conn.status === 200
  end

  test "resource/2 patch" do
    conn = conn(:patch, "/users/1")
      |> Sugar.RouterTest.Router.call([])

    assert conn.state === :sent
    assert conn.status === 200
  end

  test "resource/2 delete" do
    conn = conn(:delete, "/users/1")
      |> Sugar.RouterTest.Router.call([])

    assert conn.state === :sent
    assert conn.status === 200
  end

  test "filter plug is run" do
    conn = conn(:get, "/get")
      |> Sugar.RouterTest.Router.call([])

    assert conn.state === :sent
    assert conn.status === 200
    assert get_resp_header(conn, "content-type") === ["text/html; charset=utf-8"]
  end

  test "resource/2 index with prepended path" do
    conn = conn(:get, "/users/2/comments")
      |> Sugar.RouterTest.Router.call([])

    assert conn.state === :sent
    assert conn.status === 200
  end

  test "parses json encoded bodies" do
    conn = conn(:post, "/post", "{\"foo\": \"baz\"}")
      |> Plug.Conn.put_req_header("content-type", "application/json")
      |> Sugar.RouterTest.Router.call([])
    assert conn.state === :sent
    assert conn.status === 200
    assert conn.params["foo"] == "baz"
  end

  test "adds matched controller and action to conn" do
    conn = conn(:get, "/get")
      |> Sugar.RouterTest.Router.call([])

    assert conn.private[:controller] === Sugar.RouterTest.Foo
    assert conn.private[:action] === :get
  end

  defmodule Foo do
    use Sugar.Controller

    def get(conn, _args) do
      conn
        |> Map.put(:resp_body, "")
        |> Map.put(:status, 200)
        |> Map.put(:state, :set)
        |> raw
    end
    def post(conn, _args) do
      conn
        |> Map.put(:resp_body, "")
        |> Map.put(:status, 200)
        |> Map.put(:state, :set)
        |> raw
    end
    def put(conn, _args) do
      conn
        |> Map.put(:resp_body, "")
        |> Map.put(:status, 200)
        |> Map.put(:state, :set)
        |> raw
    end
    def patch(conn, _args) do
      conn
        |> Map.put(:resp_body, "")
        |> Map.put(:status, 200)
        |> Map.put(:state, :set)
        |> raw
    end
    def delete(conn, _args) do
      conn
        |> Map.put(:resp_body, "")
        |> Map.put(:status, 200)
        |> Map.put(:state, :set)
        |> raw
    end
    def options(conn, _args) do
      conn
        |> Map.put(:resp_body, "")
        |> Map.put(:status, 200)
        |> Map.put(:state, :set)
        |> raw
    end
    def any(conn, _args) do
      conn
        |> Map.put(:resp_body, "")
        |> Map.put(:status, 200)
        |> Map.put(:state, :set)
        |> raw
    end
    def trace(conn, _args) do
      conn
        |> Map.put(:resp_body, "")
        |> Map.put(:status, 200)
        |> Map.put(:state, :set)
        |> raw
    end
  end

  defmodule Bar do
    use Sugar.Controller

    def index(conn, _args) do
      conn
        |> Map.put(:resp_body, "")
        |> Map.put(:status, 200)
        |> Map.put(:state, :set)
        |> raw
    end
    def create(conn, _args) do
      conn
        |> Map.put(:resp_body, "")
        |> Map.put(:status, 200)
        |> Map.put(:state, :set)
        |> raw
    end
    def show(conn, _args) do
      conn
        |> Map.put(:resp_body, "")
        |> Map.put(:status, 200)
        |> Map.put(:state, :set)
        |> raw
    end
    def update(conn, _args) do
      conn
        |> Map.put(:resp_body, "")
        |> Map.put(:status, 200)
        |> Map.put(:state, :set)
        |> raw
    end
    def patch(conn, _args) do
      conn
        |> Map.put(:resp_body, "")
        |> Map.put(:status, 200)
        |> Map.put(:state, :set)
        |> raw
    end
    def delete(conn, _args) do
      conn
        |> Map.put(:resp_body, "")
        |> Map.put(:status, 200)
        |> Map.put(:state, :set)
        |> raw
    end
  end

  defmodule Baz do
    use Sugar.Controller

    def index(conn, _args) do
      conn
        |> Map.put(:resp_body, "")
        |> Map.put(:status, 200)
        |> Map.put(:state, :set)
        |> raw
    end
  end

  defmodule Router do
    use Sugar.Router

    plug :set_utf8_json

    get         "/get",     Foo, :get
    get         "/get/:id", Foo, :get
    post        "/post",    Foo, :post
    put         "/put",     Foo, :put
    patch       "/patch",   Foo, :patch
    delete      "/delete",  Foo, :delete
    options     "/options", "HEAD,GET"
    any         "/any",     Foo, :any
    raw :trace, "/trace",   Foo, :trace

    resource :users,    Bar
    resource :comments, Baz, prepend_path: "/users/:user_id",
                             only: [:index]

    def set_utf8_json(%Plug.Conn{state: state} = conn, _) when state in [:unset, :set] do
      conn |> put_resp_header("content-type", "application/json; charset=utf-8")
    end
    def set_utf8_json(conn, _), do: conn
  end
end
