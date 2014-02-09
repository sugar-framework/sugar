defmodule Sugar.Templates.Engines.ErlyDTL do
  @behaviour Sugar.Templates.Engine
  @moduledoc """
  ErlyDTL template engine
  """

  ## Callbacks

  def compile(name) do
    path = Path.expand('lib/views/#{name}.dtl')
    :erlydtl.compile(String.to_char_list!(path), binary_to_atom("Sugar.Templates.User." <> name), [out_dir: "./ebin"])
    :ok
  end

  def render(name, vars) do
    {:ok, tpl} = apply(binary_to_atom("Sugar.Templates.User." <> name), :render, [vars])
    {:ok, String.from_char_list!(tpl)}
  end
end