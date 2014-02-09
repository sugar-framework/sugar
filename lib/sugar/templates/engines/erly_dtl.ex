defmodule Sugar.Templates.Engines.ErlyDTL do
  @behaviour Sugar.Templates.Engine
  @moduledoc """
  ErlyDTL template engine
  """

  @extensions ["dtl"]

  ## Callbacks

  def compile(template) do
    :erlydtl.compile(String.to_char_list!(template.filename), binary_to_atom(template.key), [out_dir: "./ebin"])
  end

  def render(template, vars) do
    {:ok, tpl} = apply(binary_to_atom(template.key), :render, [vars])
    {:ok, String.from_char_list!(tpl)}
  end
end