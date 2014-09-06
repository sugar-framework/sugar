defmodule Sugar.App do
  use Application

  ## API

  @doc """
  Used in starting the server with `mix server`.

  ## Arguments

  * `opts` - `Keyword` - options to pass to Plug/Cowboy
  """
  def run(opts) do
    IO.puts "Starting Sugar on port #{get_port(opts)}..."

    if Keyword.has_key? Sugar.App.config, :router do
      router = Sugar.App.config[:router]
    else
      router = Router
    end

    Plug.Adapters.Cowboy.http router, [], opts
  end

  @doc """
  Starts the application, checking if it's already been started.
  """
  def start do
    case :application.start(:sugar) do
      :ok -> :ok
      {:error, {:already_started, :sugar}} -> :ok
    end
  end

  ## Callbacks

  @doc """
  Callback for `start/2`. Starts the supervisor.
  """
  def start(_type, _args) do
    :ok = Application.ensure_started(:templates)
    Sugar.Views.Finder.all("lib/views")
      |> Sugar.Templates.compile
    Sugar.Supervisor.start_link
  end

  @doc """
  Callback for `stop/1`.
  """
  def stop(_state) do
    :ok
  end

  ## Helpers

  @doc """
  Grabs the application's running port number or `4000` when
  `opts` doesn't contain the `:port` keyword.

  ## Arguments

  * `opts` - `Keyword` - options

  ## Returns

  `Integer`
  """
  def get_port(opts) do
    case opts[:port] do
      nil -> 4000
      _ ->
        abs(opts[:port])
    end
  end

  @doc """
  Loads userland configuration if available.

  ## Returns

  `Keyword`
  """
  def config do
    config = Keyword.new
    if loaded? Config do
      config = apply(Config, :config, [])
    end
    config
  end

  defp loaded?(module) do
    is_tuple :code.is_loaded(module)
  end
end
