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
  @spec all(binary) :: [Sugar.Templates.Template.t]
  def all(root) do
    root <> "/**/*.*"
      |> Path.wildcard
      |> Enum.map(fn (path) -> build(path) end)
  end

  @doc """
  Finds a template within `root` and with a given `key`

  ## Arguments

  * `root` - `String` - path to search for template
  * `key` - `String` - key (aka local path) of template desired

  ## Returns

  `Sugar.Templates.Template`
  """
  @spec one(binary, binary) :: Sugar.Templates.Template.t | {:error,:notfound}
  def one(root, key) do
    path = Path.join(root, key)
    path = if Path.extname(path) == "", do: path <> ".*", else: path
    path = path |> Path.wildcard 
                |> List.first 
                || ""

    if File.exists?(path) do
      build(path, key)
    else
      { :error, :notfound }
    end
  end

  defp build(path) do
    key = Path.basename(path)
    build(path, key)
  end
  defp build(path, key) do
    %Sugar.Templates.Template{
      key: key,
      engine: path |> get_ext |> get_engine,
      source: File.read!(path),
      updated_at: File.stat!(path) |> Map.get(:mtime)
    }
  end

  defp get_engine(ext) do
    case ext do
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
