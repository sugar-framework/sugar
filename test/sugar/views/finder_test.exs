defmodule Sugar.Views.FinderTest do
  use ExUnit.Case

  test "all/1" do
    templates = Sugar.Views.Finder.all("test/fixtures/view_finder")
    expected = %Sugar.Templates.Template{
                    engine: Sugar.Templates.Engines.EEx,
                    key: "index.html.eex",
                    source: ""
                  }

    assert Enum.count(templates) === 1
    template = templates |> hd

    assert template.key === expected.key
    assert template.engine === expected.engine
    assert template.source === expected.source
  end

  test "one/2" do
    template = Sugar.Views.Finder.one("test/fixtures/view_finder", "index.html.eex")
    expected = %Sugar.Templates.Template{
                  engine: Sugar.Templates.Engines.EEx,
                  key: "index.html.eex",
                  source: ""
                }

    assert template.key === expected.key
    assert template.engine === expected.engine
    assert template.source === expected.source
  end

  test "one/2 without extension" do
    template = Sugar.Views.Finder.one("test/fixtures/view_finder", "index")
    expected = %Sugar.Templates.Template{
                  engine: Sugar.Templates.Engines.EEx,
                  key: "index.html.eex",
                  source: ""
                }

    assert template.key === expected.key
    assert template.engine === expected.engine
    assert template.source === expected.source
  end

  test "one/2 when view does not exist" do
    template = Sugar.Views.Finder.one("test/fixtures/view_finder", "not_found.html.eex")
    expected = { :error, :notfound }

    assert template === expected
  end
end
