defmodule Sugar.PlugTest do
  use ExUnit.Case, async: true
  use Plug.Test
  import Sugar.Plug

  test "call/2" do
    conn = conn('GET', "/")
    result = call(conn, [])
    {:ok, result_conn} = result
    
    assert result_conn.state === :sent
  end
end
