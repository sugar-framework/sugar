defmodule Mix.Tasks.Server do
  use Mix.Task

  #@shortdoc "Runs Sugar and children"
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
    Mix.Task.run "compile.sugar", args

    if Keyword.has_key? opts, :port do
      opts = Keyword.update!(opts, :port, &binary_to_integer(&1))
    end

    opts = add_config(opts)
    router = Sugar.Config.get(:placid, :router, Router)
    router.run

    # TODO: is there a better way than `Code.ensure_loaded?(Mix.Tasks.ServerTest)`?
    unless (Code.ensure_loaded?(IEx) && IEx.started?) || Code.ensure_loaded?(Mix.Tasks.ServerTest) do
      :timer.sleep(:infinity)
    end
  end

  defp add_config(options) do
    router = Sugar.Config.get(:sugar, :router, Router)
    config = Sugar.Config.get(router) || []

    Keyword.merge config, options
  end

  def binary_to_integer(port) do
    case Integer.parse port do
      :error -> nil
      {i, _} -> i
    end
  end
end
