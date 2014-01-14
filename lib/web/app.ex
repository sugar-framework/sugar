defmodule Web.App do  
  use Application.Behaviour
  require Lager

  ## API

  def run(opts) do
    Lager.info "Starting Web on port #{get_port(opts)}..."

    Plug.Adapters.Cowboy.http Web.Plug, [], opts
  end

  def start do
    case :application.start(:web) do
      :ok -> :ok
      {:error, {:already_started, :web}} -> :ok
    end
  end

  ## Callbacks

  @doc """
  Callback for `start/2`. Starts the supervisor.
  """
  def start(_type, _args) do
    Web.Supervisor.start_link
  end

  @doc """
  Callback for `stop/1`.
  """
  def stop(_state) do
    :ok
  end

  ## Helpers

  @doc """
  `get_route/1` grabs the application's running port number or `4000`
  when `opts` doesn't contain the `:port` keyword.

  ## Arguments

    - `opts` - Keyword List - connection instance

  ## Returns

    - `port` - Integer
  """
  def get_port(opts) do
    case opts[:port] do
      nil -> 4000
      _ -> opts[:port]
    end
  end
end