defmodule Sugar.App do
  use Application

  ## API

  @doc """
  Starts the application, checking if it's already been started.
  """
  @spec start() :: :ok
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
  @spec start(atom, Keyword.t) :: {:ok, pid}
  def start(_type, _args) do
    :ok = Application.ensure_started(:templates)
    _ = Sugar.Config.get(:sugar, :views_dir, "lib/#{Mix.Project.config[:app]}/views")
      |> Sugar.Views.Finder.all
      |> Sugar.Templates.compile
    Sugar.Supervisor.start_link
  end

  @doc """
  Callback for `stop/1`.
  """
  @spec stop(any) :: :ok
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
  @spec get_port(Keyword.t) :: pos_integer
  def get_port(opts) do
    case opts[:port] do
      nil -> 4000
      _ ->
        abs(opts[:port])
    end
  end
end
