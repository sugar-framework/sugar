defmodule Sugar.Router.Filters do
  ## Macros

  @doc """
  Macro used to add necessary items to a router.
  """
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      @filters []
      @before_compile unquote(__MODULE__)
    end
  end

  @doc """
  Defines a default route to catch all unmatched routes.
  """
  defmacro __before_compile__(env) do
    module = env.module
    filters = Enum.reverse(Module.get_attribute(module, :filters))
    _escaped = Macro.escape(filters)
  end

  defmacro filter(spec) do
    quote do
      @filters [unquote(spec)|@filters]
    end
  end
end
