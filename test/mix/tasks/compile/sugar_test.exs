defmodule Mix.Tasks.Compile.SugarTest do
  use ExUnit.Case

  test "manifests/0" do
    manifests = Mix.Tasks.Compile.Sugar.manifests

    assert manifests === [Path.join(Mix.Project.compile_path, ".compile.sugar")]
  end

  test "run/1 with force" do
    args = ["--force"]
    Mix.Tasks.Compile.Sugar.run(args)
    status = :application.ensure_started(:templates)

    assert status === :ok
  end

  test "run/1 without force" do
    args = []
    Mix.Tasks.Compile.Sugar.run(args)
    status = :application.ensure_started(:templates)

    assert status === :ok
  end
end
