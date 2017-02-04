defmodule Sugar.Config do
  @moduledoc false

  @default_options [
    http:  [ port: 4000 ],
    https: [ certfile: "",
             keyfile: "",
             port: 4443 ]
  ]

  @spec get(atom) :: any
  def get(module) when module != :sugar do
    get(:sugar, module)
  end

  @spec get(atom, atom) :: any
  def get(:sugar, key) do
    _get(key)
  end
  def get(module, key) do
    _get(module)[key]
  end

  @spec get(atom, atom, any) :: any
  def get(:sugar, key, default) do
    get(:sugar, key) || default
  end
  def get(module, key, default) do
    get(module, key) || default
  end

  defp _get(key) do
    env = Application.get_env(:sugar, key)
    if Keyword.keyword?(env) do
      @default_options |> Keyword.merge(env)
    else
      env
    end
  end
end
