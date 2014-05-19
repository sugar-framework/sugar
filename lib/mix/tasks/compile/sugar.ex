defmodule Mix.Tasks.Compile.Sugar do
  use Mix.Task

  # @hidden true
  @shortdoc "Compile Sugar source files"
  @recursive true
  @manifest ".compile.sugar"

  @moduledoc """
  A task to compile Sugar source files.

  ## Command line options

  * `--force` - forces compilation regardless of mod times;

  """

  @switches [ force: :boolean, docs: :boolean, ignore_module_conflict: :boolean,
              debug_info: :boolean, warnings_as_errors: :boolean ]

  @doc """
  Runs this task.
  """
  def run(args) do
    OptionParser.parse(args, switches: @switches) |> elem(0)
      |> do_compile
  end

  @doc """
  The manifests for this compiler.
  """
  def manifests, do: [manifest]
  defp manifest, do: Path.join(Mix.Project.compile_path, @manifest)

  defp do_compile(opts) do
    compile_path = Mix.Project.compile_path
    watch_exts = ["dtl","haml","eex"]
    source_paths = ["lib/views"]
    templates = Sugar.Templates.Finder.all("lib/views")

    # Source files + Mix setup + Dynamo config + Templates
    to_watch = Mix.Utils.extract_files(source_paths, watch_exts)
    to_watch = Mix.Tasks.Compile.Elixir.manifests ++ to_watch
    # to_watch = to_watch ++ Enum.map(templates, &template_mtime(&1))

    manifest = manifest()

    if opts[:force] || Mix.Utils.stale?(to_watch, [manifest]) do
      # to_compile = Mix.Utils.extract_files(source_paths, watch_exts)
      File.mkdir_p!(compile_path)
      Code.prepend_path compile_path

      Templates.Supervisor.start_link
      templates
        |> Templates.compile

      compiled = Templates.get_all_templates
        |> Map.keys

      Mix.Utils.write_manifest(manifest, compiled)
    end
  end

  # defp template_mtime(%Templates.Template{key: key, updated_at: updated_at}) do
  #   { key, updated_at }
  # end
end
