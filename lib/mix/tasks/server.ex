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

    opts = opts |> Keyword.update(:port, 4000, &binary_to_integer(&1))
    
    Mix.shell.info "== Sugar running in http://127.0.0.1:#{opts[:port]} =="

    opts = add_config opts
    router = Sugar.Config.get(:sugar, :router, Router)
    router.run opts

    # TODO: is there a better way than `Code.ensure_loaded?(Mix.Tasks.ServerTest)`?
    unless (Code.ensure_loaded?(IEx) && IEx.started?) || Code.ensure_loaded?(Mix.Tasks.ServerTest) do
      :timer.sleep(:infinity)
    end
  end

  defp add_config(options) do
    router = Sugar.Config.get(:sugar, :router, Router)
    config = Sugar.Config.get(router) || []

    config = Keyword.put_new config, :http, []
    http = Keyword.merge config[:http], options
    Keyword.put config, :http, http
  end

  def binary_to_integer(port) do
    case Integer.parse port do
      :error -> nil
      {i, _} -> i
    end
  end
end
