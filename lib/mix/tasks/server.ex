defmodule Mix.Tasks.Server do
  use Mix.Task

  @shortdoc "Run all Dynamos in a web server"
  @recursive true

  @moduledoc """
  Runs all registered Dynamos in their servers.

  ## Command line options

    * `-h`, `--host` - bind to the given ip
    * `-p`, `--port` - the port to listen to

  """

  def run(args) do
    opts = OptionParser.parse(args, aliases: [h: :host, p: :port]) |> elem(0)
    Mix.Task.run "app.start", args

    if opts[:port] do
      opts = Keyword.update!(opts, :port, &binary_to_integer(&1))
    end

    Web.App.run opts

    unless Code.ensure_loaded?(IEx) && IEx.started? do
      :timer.sleep(:infinity)
    end
  end
end