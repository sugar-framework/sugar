defmodule Sugar.ControllerTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Sugar.Controller
  import Plug.Conn

  test "json/2" do
    conn = conn(:get, "/")
      |> Map.put(:resp_body, "")
      |> Map.put(:state, :set)
      |> json([])

    assert conn.state === :sent
    assert get_resp_header(conn, "content-type") === ["application/json; charset=utf-8"]
    assert conn.resp_body === "[]"
  end

  test "raw/1" do
    conn = conn(:get, "/")
      |> Map.put(:resp_body, "")
      |> Map.put(:state, :set)
      |> raw

    assert conn.state === :sent
  end

  test "render/4 without opts" do
    conn = conn(:get, "/")
      |> Map.put(:state, :set)
      |> render("", [])

    assert conn.state === :sent
    assert get_resp_header(conn, "content-type") === ["text/html; charset=utf-8"]
  end

  test "render/4 with opts" do
    conn = conn(:get, "/")
      |> Map.put(:state, :set)
      |> render("", [content_type: "text/html"])

    assert conn.state === :sent
    assert get_resp_header(conn, "content-type") === ["text/html; charset=utf-8"]
  end

  test "halt!/2 without opts" do
    conn = conn(:get, "/")
      |> Map.put(:state, :set)
      |> halt!

    assert conn.state === :sent
    assert conn.status === 401
  end

  test "halt!/2 with opts" do
    conn = conn(:get, "/")
      |> Map.put(:state, :set)
      |> halt!([status: 401, message: "Halted"])

    assert conn.state === :sent
    assert conn.status === 401
    assert conn.resp_body === "Halted"
  end

  test "not_found/2" do
    conn = conn(:get, "/")
      |> Map.put(:state, :set)
      |> not_found

    assert conn.state === :sent
    assert conn.status === 404
    assert conn.resp_body === "Not Found"
  end

  test "forward/4 without args" do
    conn = conn(:get, "/")
      |> Map.put(:state, :set)
      |> forward(Sugar.ControllerTest.Controller, :create)

    assert conn.state === :sent
  end

  test "forward/4 with args" do
    conn = conn(:get, "/")
      |> Map.put(:state, :set)
      |> forward(Sugar.ControllerTest.Controller, :create, [])

    assert conn.state === :sent
  end

  test "redirect/2 without opts" do
    conn = conn(:get, "/")
      |> Map.put(:resp_body, "")
      |> Map.put(:state, :set)
      |> redirect("/login")

    assert conn.state === :sent
    assert conn.status === 302
  end

  test "redirect/2 with opts" do
    conn = conn(:get, "/")
      |> Map.put(:resp_body, "")
      |> Map.put(:state, :set)
      |> redirect("/login", [status: 301])

    assert conn.state === :sent
    assert conn.status === 301
  end

  test "resp already sent on set content-type" do
    conn = conn(:get, "/")
      |> Map.put(:state, :sent)
      |> json([])

    assert conn.state === :sent
  end

  test "resp already sent on set header" do
    conn = conn(:get, "/")
      |> Map.put(:state, :sent)
      |> redirect("/login")

    assert conn.state === :sent
  end

  defmodule Controller do
    def create(conn, _args) do
      halt! conn, [status: 204, message: "Created"]
    end
  end
end
