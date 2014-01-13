defmodule Controller do
  defmacro __using__(_) do
    quote do
      import Plug.Connection
    end
  end
end