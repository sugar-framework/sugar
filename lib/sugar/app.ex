defmodule Sugar.App do  
  use Application.Behaviour
  require Lager

  ## API

  @doc """
  Used in starting the server with `mix server`.

  ## Arguments

    - `opts` - `Keyword` - options to pass to Plug/Cowboy
  """
  def run(opts) do
    Lager.info "Starting Sugar on port #{get_port(opts)}..."

    if Keyword.has_key?(Sugar.App.config, :router) do
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

    - `opts` - `Keyword` - options

  ## Returns

    - `port` - `Integer`
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

  - `Keyword`
  """
  def config do
    config = Keyword.new
    if loaded? Config do
      config = apply(Config, :config, [])
    end
    config
  end

  @doc """
  Wraps `Lager` log functions in conditionals to allow
  userland configuration to logging off and on.

  ## Arguments

  - `level` - `Atom` - One of:
      - `:debug`
      - `:info`
      - `:notice`
      - `:warning`
      - `:error`
      - `:critical`
      - `:alert`
      - `:emergency`
  """
  def log(:debug, message) do
    if Keyword.has_key?(Sugar.App.config, :log) && Sugar.App.config[:log] do
      Lager.debug message
    end
  end
  def log(:info, message) do
    if Keyword.has_key?(Sugar.App.config, :log) && Sugar.App.config[:log] do
      Lager.info message
    end
  end
  def log(:notice, message) do
    if Keyword.has_key?(Sugar.App.config, :log) && Sugar.App.config[:log] do
      Lager.notice message
    end
  end
  def log(:warning, message) do
    if Keyword.has_key?(Sugar.App.config, :log) && Sugar.App.config[:log] do
      Lager.warning message
    end
  end
  def log(:error, message) do
    if Keyword.has_key?(Sugar.App.config, :log) && Sugar.App.config[:log] do
      Lager.error message
    end
  end
  def log(:critical, message) do
    if Keyword.has_key?(Sugar.App.config, :log) && Sugar.App.config[:log] do
      Lager.critical message
    end
  end
  def log(:alert, message) do
    if Keyword.has_key?(Sugar.App.config, :log) && Sugar.App.config[:log] do
      Lager.alert message
    end
  end
  def log(:emergency, message) do
    if Keyword.has_key?(Sugar.App.config, :log) && Sugar.App.config[:log] do
      Lager.emergency message
    end
  end

  defp loaded?(module) do
    is_tuple :code.is_loaded(module)
  end
end