defmodule Mix.Tasks.Compile.Sugar do
  use Mix.Task

  @hidden true
  @shortdoc "Compile Sugar source files"
  @recursive true
  @manifest ".compile.sugar"

  @moduledoc """
  A task to compile Sugar source files.

  ## Command line options

  * `--force` - forces compilation regardless of mod times
  * `--path` - overrides the default location to search 

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
  def manifests, do: [manifest()]
  defp manifest, do: Path.join(Mix.Project.compile_path, @manifest)

  defp do_compile(opts) do
    app = Mix.Project.config[:app]
    compile_path = Mix.Project.compile_path
    watch_exts = ["dtl","haml","eex"]
    opts = [ app: app,
             path: "lib/#{app}/views",
             compile_path: compile_path ] |> Keyword.merge(opts)
    source_paths = [opts[:path]]

    templates = Sugar.Views.Finder.all(opts[:path])

    # Source files + Mix setup + Dynamo config + Templates
    to_watch = Mix.Utils.extract_files(source_paths, watch_exts)
    to_watch = Mix.Tasks.Compile.Elixir.manifests ++ to_watch
    # to_watch = to_watch ++ Enum.map(templates, &template_mtime(&1))

    manifest = manifest()

    if opts[:force] || Mix.Utils.stale?(to_watch, [manifest]) do
      # to_compile = Mix.Utils.extract_files(source_paths, watch_exts)
      File.mkdir_p!(compile_path)
      true = Code.prepend_path compile_path

      :ok = :application.ensure_started(:templates)
      _ = templates
        |> Enum.map(fn(template) ->
          {:ok,t} = template.engine.compile template
          name = template.key |> String.replace("/", "_")
          
          if t.binary do
            File.write! Path.join(compile_path, "#{name}.beam"), t.binary
          end
          Mix.shell.info "Generated #{name}"
        end)

      # compiled =
      Sugar.Templates.get_all_templates
        |> Map.keys

      # Mix.Utils.write_manifest(manifest, compiled)
    end
  end

  # defp template_mtime(%Templates.Template{key: key, updated_at: updated_at}) do
  #   { key, updated_at }
  # end
end
