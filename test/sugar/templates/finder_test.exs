defmodule Sugar.Templates.FinderTest do
  use ExUnit.Case

  test "all/1" do
    templates = Sugar.Templates.Finder.all("test/fixtures/view_finder")
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
    template = Sugar.Templates.Finder.one("test/fixtures/view_finder", "index.html.eex")
    expected = %Sugar.Templates.Template{
                  engine: Sugar.Templates.Engines.EEx,
                  key: "index.html.eex",
                  source: ""
                }

    assert template.key === expected.key
    assert template.engine === expected.engine
    assert template.source === expected.source
  end
end
