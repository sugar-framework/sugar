defmodule Mix.Tasks.ServerTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "run/1 with port" do
    args = ["--port=8080"]
    capture_io(fn ->
      Mix.Tasks.Server.run(args)
    end)
  end

  test "run/1 without port" do
    args = []
    capture_io(fn ->
      Mix.Tasks.Server.run(args)
    end)
  end
end
