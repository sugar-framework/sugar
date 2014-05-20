defmodule Sugar.ExceptionsTest do
  use ExUnit.Case
  use Plug.Test

  test "init/1" do
    assert Sugar.Plugs.Exceptions.init(opts) === opts
  end

  test "wrap/2 with no error" do
    fun = fn(conn) -> conn |> resp(200, "") end
    conn = conn(:get, "/")
      |> Sugar.Plugs.Exceptions.wrap(opts, fun)

    assert conn.status === 200
    assert conn.resp_body === ""
  end

  test "wrap/2 with error" do
    fun = fn(conn) ->
      conn = conn |> resp(200, "")
      raise ArgumentError
      conn
    end

    conn = conn(:get, "/") |> Sugar.Plugs.Exceptions.wrap(opts, fun)

    assert conn.status == 500
    refute conn.resp_body === ""
  end

  defp opts do
    [dev_template: "<html><head><title></title></head><body></body></html>"]
  end
end
