defmodule Web.Handler.Request do
  defrecord State,
    config: nil

  def init({:tcp, :http}, req, config) do
    {:ok, req, State.new config: config }
  end

  def handle(req, state) do
    {:ok, req2} = :cowboy_req.reply(200, [
      {"content-type", "text/html"}
    ], "Hello!", req)
    {:ok, req2, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end