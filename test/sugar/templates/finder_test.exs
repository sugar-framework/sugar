defmodule Sugar.Templates.FinderTest do
  use ExUnit.Case

  test "all/1" do
    templates = Sugar.Templates.Finder.all("test/fixtures/view_finder")
    expected = [ %Templates.Template{
                    engine: Templates.Engines.EEx,
                    key: "index.html.eex",
                    source: "",
                    updated_at: {{2014, 5, 18}, {21, 21, 25}}
                  } ]

    assert templates === expected
  end

  test "one/2" do
    template = Sugar.Templates.Finder.one("test/fixtures/view_finder", "index.html.eex")
    expected = %Templates.Template{
                  engine: Templates.Engines.EEx,
                  key: "index.html.eex",
                  source: "",
                  updated_at: {{2014, 5, 18}, {21, 21, 25}}
                }

    assert template === expected
  end
end
