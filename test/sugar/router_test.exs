defmodule Sugar.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use Sugar.Router

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

  test "resource/2" do
    assert true === true
  end

  defmodule Foo do
    use Sugar.Controller

    def get(conn, _args) do
      render conn, ""
    end
    def post(conn, _args) do
      render conn, ""
    end
    def put(conn, _args) do
      render conn, ""
    end
    def patch(conn, _args) do
      render conn, ""
    end
    def delete(conn, _args) do
      render conn, ""
    end
    def options(conn, _args) do
      render conn, ""
    end
    def any(conn, _args) do
      render conn, ""
    end
  end

  defmodule Router do
    use Sugar.Router

    get      "/get",     Foo, :get
    post     "/post",    Foo, :post
    put      "/put",     Foo, :put
    patch    "/patch",   Foo, :patch
    delete   "/delete",  Foo, :delete
    options  "/options", Foo, :options
    any      "/any",     Foo, :any
  end
end
