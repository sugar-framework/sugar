defmodule Sugar.Templates.Engine do
  @moduledoc """
  Specification of the template engine API implemented 
  by engines.
  """
  use Behaviour

  @type template :: Sugar.Template.t
  @type vars :: list | Keyword.t

  @doc """
  Compiles a `template`.
  """
  defcallback compile(record) :: :ok

  @doc """
  Renders a compiled template based on the given `template` record.
  """
  defcallback render(record, vars) :: {:ok, iodata}
end