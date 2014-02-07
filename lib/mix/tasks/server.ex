defmodule Mix.Tasks.Server do
  use Mix.Task

  @shortdoc "Run all Dynamos in a web server"
  @recursive true

  @moduledoc """
  Runs Sugar and all registered children in their servers.

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

    Sugar.App.run add_config(opts)

    unless Code.ensure_loaded?(IEx) && IEx.started? do
      :timer.sleep(:infinity)
    end
  end

  def add_config(options) do
    config = Sugar.App.config

    if Keyword.has_key? config, :server do
      Keyword.merge config[:server], options
    else
      []
    end
  end
end