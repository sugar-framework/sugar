defmodule Sugar.ControllerTest do
  use ExUnit.Case, async: false 
  use Plug.Test

  import Sugar.Controller
  import Plug.Conn

  test "static/2 file exists" do
    conn = conn(:get, "/")
      |> Map.put(:state, :set)
      |> static("index.html")

    assert conn.state === :sent
    assert get_resp_header(conn, "content-type") === ["text/html; charset=utf-8"]
    assert conn.status === 200
    refute conn.resp_body === ""
  end

  test "static/2 file no exists" do
    conn = conn(:get, "/")
      |> Map.put(:state, :set)
      |> static("nofile.html")

    assert conn.state === :sent
    assert conn.status === 404
    assert conn.resp_body === "Not Found"
  end

  test "json/2" do
    conn = conn(:get, "/")
      |> Map.put(:state, :set)
      |> json([])

    assert conn.status === 200
    assert conn.state === :sent
    assert get_resp_header(conn, "content-type") === ["application/json; charset=utf-8"]
    assert conn.resp_body === "[]"
  end

  test "status/2 and json/2" do
    conn = conn(:get, "/")
      |> Map.put(:state, :set)
      |> status(201)
      |> json([])

    assert conn.status === 201
    assert conn.state === :sent
    assert get_resp_header(conn, "content-type") === ["application/json; charset=utf-8"]
    assert conn.resp_body === "[]"
  end

  test "headers/2 and json/2" do
    conn = conn(:get, "/")
      |> Map.put(:state, :set)
      |> headers([{"content-type", "application/vnd.company.myapp.customer-v1+json"}])
      |> json([])

    assert conn.state === :sent
    assert get_resp_header(conn, "content-type") === ["application/vnd.company.myapp.customer-v1+json"]
    assert conn.resp_body === "[]"
  end

  test "raw/1" do
    conn = conn(:get, "/")
      |> Map.put(:state, :set)
      |> Map.put(:resp_body, "")
      |> raw

    assert conn.state === :sent
  end

  test "render/4 without assigns and opts" do
    build_template
    conn = conn(:get, "/")
      |> Map.put(:state, :set)
      |> render("index.html.eex")

    assert conn.state === :sent
    assert get_resp_header(conn, "content-type") === ["text/html; charset=utf-8"]
    destroy_template
  end

  test "render/4 with assigns and without opts" do
    build_template
    conn = conn(:get, "/")
      |> Map.put(:state, :set)
      |> render("index.html.eex", [])

    assert conn.state === :sent
    assert get_resp_header(conn, "content-type") === ["text/html; charset=utf-8"]
    destroy_template
  end

  test "render/4 with assigns and opts" do
    build_template
    conn = conn(:get, "/")
      |> Map.put(:state, :set)
      |> render("index.html.eex", [], [content_type: "text/html"])

    assert conn.state === :sent
    assert get_resp_header(conn, "content-type") === ["text/html; charset=utf-8"]
    destroy_template
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
      |> Map.put(:state, :set)
      |> redirect("/login")

    assert conn.state === :sent
    assert conn.status === 302
  end

  test "redirect/2 with opts" do
    conn = conn(:get, "/")
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

  defp build_template do
    File.write!("lib/sugar/views/index.html.eex", "")
  end

  defp destroy_template do
    File.rm!("lib/sugar/views/index.html.eex")
  end

  defmodule Controller do
    def create(conn, _args) do
      halt! conn, [status: 204, message: "Created"]
    end
  end
end
