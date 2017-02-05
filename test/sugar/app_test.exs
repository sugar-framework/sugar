defmodule Sugar.AppTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO
  import Sugar.App

  test "start/0" do
    capture_io(fn ->
      assert start() === :ok
      # starting twice should still return :ok
      assert start() === :ok
    end)
  end

  test "start/2" do
    assert true === true
  end

  test "stop/1" do
    assert stop(nil) === :ok
  end

  test "get_port/1" do
    assert get_port([]) === 4000
    assert get_port([port: 8888]) === 8888
    assert get_port([port: -8888]) === 8888
  end
end

defmodule Router do
  use Sugar.Router
end
