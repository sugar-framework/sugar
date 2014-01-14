# awesome example by @josevalim: https://gist.github.com/josevalim/7432084
defmodule Web.Controller do
  @doc """
  `__using__/1` macro used to add necessary items to a controller.
  """
  defmacro __using__(_) do
    quote do
      import unquote(Plug.Connection)
    end
  end
end