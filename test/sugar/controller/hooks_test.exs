defmodule Sugar.Controller.HooksTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "before_hook/1 all" do
    conn = conn(:get, "/")
      |> Sugar.Controller.HooksTest.Router.call([])

    assert get_resp_header(conn, "content-type") === ["application/json; charset=utf-8"]
  end

  test "before_hook/2 all + only show" do
    conn = conn(:get, "/show")
      |> Sugar.Controller.HooksTest.Router.call([])

    assert get_resp_header(conn, "content-type") === ["application/json; charset=utf-8"]
    assert conn.assigns[:id] === 1

    conn = conn(:get, "/")
      |> Sugar.Controller.HooksTest.Router.call([])

    assert get_resp_header(conn, "content-type") === ["application/json; charset=utf-8"]
    refute conn.assigns[:id] === 1
  end

  test "after_hook/1 all" do
    conn = conn(:get, "/")
      |> Sugar.Controller.HooksTest.Router.call([])

    assert conn.private[:id] === 2
  end

  test "after_hook/2 all + only show" do
    conn = conn(:get, "/show")
      |> Sugar.Controller.HooksTest.Router.call([])

    assert conn.state === :sent
    assert conn.private[:id] === 2

    conn = conn(:get, "/")
      |> Sugar.Controller.HooksTest.Router.call([])

    refute conn.state === :sent
    assert conn.private[:id] === 2
  end

  defmodule Router do
    use Sugar.Router
    alias Sugar.Controller.HooksTest.Controller

    get "/", Controller, :index
    get "/show", Controller, :show
  end

  defmodule Controller do
    use Sugar.Controller

    before_hook :set_json
    before_hook :set_assign, only: [:show]

    after_hook :send, only: [:show]
    after_hook :set_private

    def index(conn, _args) do
      conn |> resp(200, "[]")
    end

    def show(conn, _args) do
      conn |> resp(200, "[]")
    end

    ## Hooks

    def set_json(conn) do
      conn |> put_resp_header("content-type", "application/json; charset=utf-8")
    end

    def set_assign(conn) do
      conn |> assign(:id, 1)
    end

    def send(conn) do
      conn |> send_resp
    end

    def set_private(conn) do
      conn |> assign_private(:id, 2)
    end
  end
end
