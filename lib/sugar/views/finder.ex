defmodule Sugar.Views.Finder do
  @moduledoc """
  Allows for finding of templates within an applications to pass off to
  Templates for compiling/rendering.
  """

  @doc """
  Finds all templates within `root`

  ## Arguments

  * `root` - `String` - path to search for templates

  ## Returns

  List of `Sugar.Templates.Template`
  """
  def all(root) do
    Path.wildcard("#{root}/**/*.*")
      |> Enum.map(fn (path) -> build(path) end)
  end

  @doc """
  Finds a template within `root` and with a given `key`

  ## Arguments

  * `root` - `String` - path to search for template
  * `key` - `String` - key (aka local path) of template desired

  ## Returns

  List of `Sugar.Templates.Template`
  """
  def one(root, key) do
    path = Path.join(root, key)
    if Path.extname(path) == "", do: path = path <> ".*"
    path = path |> Path.wildcard 
                |> List.first 
                || ""

    if File.exists?(path) do
      build(path)
    else
      { :error, :notfound }
    end
  end

  defp build(path) do
    %Sugar.Templates.Template{
      key: Path.basename(path),
      engine: path |> get_ext |> get_engine,
      source: File.read!(path),
      updated_at: File.stat!(path).mtime
    }
  end

  defp get_engine(ext) do
    case ext do
      "dtl"  -> Sugar.Templates.Engines.ErlyDTL
      "haml" -> Sugar.Templates.Engines.Calliope
      _      -> Sugar.Templates.Engines.EEx
    end
  end

  defp get_ext(path) do
    case Path.extname(path) do
      "." <> ext -> ext
      _ -> nil
    end
  end
end
