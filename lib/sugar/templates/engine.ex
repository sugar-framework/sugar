defmodule Sugar.Templates.Engine do
  @moduledoc """
  Specification of the template engine API implemented 
  by engines.
  """
  use Behaviour

  @type name :: binary | atom
  @type vars :: list | Keyword.t

  @doc """
  Compiles a `template` as the given `name`.
  """
  defcallback compile(name) :: :ok

  @doc """
  Renders a compiled template based on the given `name`.
  """
  defcallback render(name, vars) :: {:ok, iodata}
end