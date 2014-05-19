defmodule Sugar.Templates.Finder do
  def all(root) do
    Path.wildcard("#{root}/**/*.*")
      |> Enum.map(fn (path) ->
        Path.relative_to(path, root)
          |> build(path)
      end)
  end

  def one(root, key) do
    path = Path.join(root, key)

    if path do
      build(key, path)
    else
      { :error, :notfound }
    end
  end

  defp build(key, path) do
    %Templates.Template{
      key: key,
      engine: path |> get_ext |> get_engine,
      source: File.read!(path),
      updated_at: File.stat!(path).mtime
    }
  end

  defp get_engine(ext) do
    case ext do
      "dtl" -> Templates.Engines.ErlyDTL
      "haml" -> Templates.Engines.Calliope
      _ -> Templates.Engines.EEx
    end
  end

  defp get_ext(path) do
    case Path.extname(path) do
      "." <> ext -> ext
      "" -> nil
      ext -> ext
    end
  end
end
