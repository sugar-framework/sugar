defmodule Sugar.ExceptionsTest do
  use ExUnit.Case
  use Plug.Test

  test "init/1" do
    assert Sugar.Plugs.Exceptions.init(opts) === opts
  end

  test "call/2 with no error" do
    conn = conn(:get, "/")
      |> Sugar.Plugs.Exceptions.call(opts)

    # assert conn.status === 200
    assert conn.resp_body === nil
  end

  test "call/2 with error" do
    conn = conn(:get, "/") |> Sugar.Plugs.Exceptions.call(opts)

    # assert conn.status == 500
    refute conn.resp_body === ""
  end

  defp opts do
    [dev_template: "<html><head><title></title></head><body></body></html>"]
  end
end
