defmodule Sugar.Request.ParsersTest do
  use ExUnit.Case, async: true
  import Plug.Test

  @parsers [ Sugar.Request.Parsers.XML ]

  def parse(conn, opts \\ []) do
    opts = Keyword.put_new(opts, :parsers, @parsers)
    Plug.Parsers.call(conn, Plug.Parsers.init(opts))
  end

  test "parses xml encoded bodies" do
    headers = [{"content-type", "application/xml"}]
    conn = parse(conn(:post, "/post", "<foo>baz</foo>", headers: headers))
    foo = conn.params.xml
          |> Enum.find(fn node ->
            node.name === :foo
          end)

    assert foo.value |> hd === "baz"
  end

  test "parses xml encoded bodies with xml nodes" do
    headers = [{"content-type", "application/xml"}]
    conn = parse(conn(:post, "/post", "<foo><bar/><baz/></foo>", headers: headers))
    foo = conn.params.xml
          |> Enum.find(fn node ->
            node.name === :foo
          end)
    bar = foo.value |> hd

    assert foo.value |> Enum.count === 2
    assert bar.name === :bar
  end

  test "parses xml encoded bodies with attributes" do
    headers = [{"content-type", "application/xml"}]
    conn = parse(conn(:post, "/post", "<foo bar=\"baz\" id=\"1\" />", headers: headers))
    foo = conn.params.xml
          |> Enum.find(fn node ->
            node.name === :foo
          end)

    assert foo.attr[:bar] === "baz"
    assert foo.attr[:id] === "1"
  end

  test "xml parser errors when body too large" do
    exception = assert_raise Plug.Parsers.RequestTooLargeError, fn ->
      headers = [{"content-type", "application/xml"}]
      parse(conn(:post, "/post", "<foo>baz</foo>", headers: headers), length: 5)
    end
    
    assert Plug.Exception.status(exception) === 413
  end
end