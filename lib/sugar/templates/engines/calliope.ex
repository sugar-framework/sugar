defmodule Sugar.Templates.Engines.Calliope do
  @behaviour Sugar.Templates.Engine
  @moduledoc """
  Calliope (HAML) template engine
  """

  ## Callbacks

  def compile(_name) do
    :ok
  end

  def render(name, vars) do
    path = Path.expand('lib/views/#{name}.haml')
    haml = File.read! path
    body = Calliope.Render.render haml, vars
    {:ok, body}
  end
end