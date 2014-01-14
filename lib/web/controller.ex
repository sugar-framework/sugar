defmodule Web.Controller do
  @doc """
  `__using__/1` macro used to add necessary items to a controller.
  """
  defmacro __using__(_) do
    quote do
      import Plug.Connection
    end
  end
end