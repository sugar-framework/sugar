defmodule Mix.Tasks.ServerTest do
  use ExUnit.Case

  test "run/1 with port" do
    args = ["--port=8080"]
    Mix.Tasks.Server.run(args)
  end

  test "run/1 without port" do
    args = []
    Mix.Tasks.Server.run(args)
  end
end
