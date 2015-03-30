defmodule Sugar.Supervisor do
  @moduledoc """
  Sugar's base supervisor.
  """
  use Supervisor

  @doc """
  Starts the supervisor. It is automatically started
  when the Sugar is started.
  """
  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  @doc """
  Callback for the supervisor to start the application's
  registered childred.
  """
  def init(opts) do
    children = []
    opts = Keyword.put(opts, :strategy, :one_for_one)

    supervise(children, opts)
  end
end
