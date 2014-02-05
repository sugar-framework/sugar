defmodule Sugar.App do  
  use Application.Behaviour
  require Lager

  ## API

  @doc """
  Used in starting the server with `mix server`.

  ## Arguments

    - `opts` - Keyword List - options to pass to Plug/Cowboy
  """
  def run(opts) do
    Lager.info "Starting Sugar on port #{get_port(opts)}..."

    Plug.Adapters.Cowboy.http Router, [], opts
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
      _ -> 
        port = opts[:port]
        if is_binary(opts[:port]) do
          port = case Integer.parse opts[:port] do
            :error -> 4000
            {i, _r} -> i
          end
        end
        abs(port)
    end
  end
end