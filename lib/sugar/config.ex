defmodule Sugar.Config do
  @moduledoc false

  @default_options [
    http:  [ port: 4000 ],
    https: [ certfile: "",
             keyfile: "",
             port: 4443 ]
  ]

  def get(module) when module != :sugar do
    get(:sugar, module)
  end
  def get(:sugar, key) do
    _get(key)
  end
  def get(module, key) do
    _get(module)[key]
  end
  def get(:sugar, key, default) do
    get(:sugar, key) || default
  end
  def get(module, key, default) do
    get(module, key) || default
  end

  defp _get(key) do
    env = Application.get_env(:sugar, key)
    if is_list(env) do
      @default_options |> Keyword.merge(env)
    else
      env
    end
  end
end
