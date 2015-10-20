defmodule Sugar.Request.ParsersTest do
  use ExUnit.Case, async: true
  import Plug.Conn
  import Plug.Test

  @parsers [ Sugar.Request.Parsers.XML ]

  def parse(conn, opts \\ []) do
    opts = Keyword.put_new(opts, :parsers, @parsers)
    Plug.Parsers.call(conn, Plug.Parsers.init(opts))
  end

  test "parses xml encoded bodies" do
    conn = conn(:post, "/post", "<foo>baz</foo>")
      |> put_req_header("content-type", "application/xml")
      |> parse
    foo = conn.params.xml
          |> Enum.find(fn node ->
            node.name === :foo
          end)

    assert foo.value |> hd === "baz"
  end

  test "parses xml encoded bodies with xml nodes" do
    conn = conn(:post, "/post", "<foo><bar/><baz/></foo>")
      |> put_req_header("content-type", "application/xml")
      |> parse
    foo = conn.params.xml
          |> Enum.find(fn node ->
            node.name === :foo
          end)
    bar = foo.value |> hd

    assert foo.value |> Enum.count === 2
    assert bar.name === :bar
  end

  test "parses xml encoded bodies with attributes" do
    conn = conn(:post, "/post", "<foo bar=\"baz\" id=\"1\" />")
      |> put_req_header("content-type", "application/xml")
      |> parse
    foo = conn.params.xml
          |> Enum.find(fn node ->
            node.name === :foo
          end)

    assert foo.attr[:bar] === "baz"
    assert foo.attr[:id] === "1"
  end

  test "xml parser errors when body too large" do
    exception = assert_raise Plug.Parsers.RequestTooLargeError, fn ->
      conn(:post, "/post", "<foo>baz</foo>")
        |> put_req_header("content-type", "application/xml")
        |> parse(length: 5)
    end

    assert Plug.Exception.status(exception) === 413
  end
end
