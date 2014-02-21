defmodule Mix.Tasks.Sugar.Scaffold do
  use Mix.Task

  @shortdoc "Creates Sugar controller, model, and view files for a resource"
  @recursive true

  @moduledoc """
  """
  def run(args) do
    opts = OptionParser.parse(args, aliases: [h: :host, p: :port]) |> elem(0)
    
  end
end