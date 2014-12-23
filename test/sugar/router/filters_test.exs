defmodule Sugar.Router.FiltersTest do
  use ExUnit.Case, async: true
  use Plug.Test

  # test "before_filter/1 all" do
  #   conn = conn(:get, "/")
  #     |> Sugar.Router.FiltersTest.Router.call([])

  #   assert get_resp_header(conn, "content-type") === ["application/json; charset=utf-8"]
  # end

  # test "after_filter/1 all" do
  #   conn = conn(:get, "/")
  #     |> Sugar.Router.FiltersTest.Router.call([])

  #   refute conn.assigns[:id] === 1
  # end

  # defmodule Router do
  #   use Sugar.Router
  #   alias Sugar.Router.FiltersTest.Controller
  #   alias Sugar.Router.FiltersTest.Filters
    
  #   before_filter Filters, :set_json
  #   after_filter Filters, :clear_assigns

  #   get "/", Controller, :index
  #   get "/show", Controller, :show
  # end

  defmodule Controller do
    use Sugar.Controller

    def index(conn, _args) do
      conn |> assign(:id, 1) |> resp(200, "[]")
    end

    def show(conn, _args) do
      conn |> resp(200, "[]")
    end
  end

  defmodule Filters do
    import Plug.Conn

    def set_json(conn) do
      conn |> put_resp_header("content-type", "application/json; charset=utf-8")
    end

    def clear_assigns(conn) do
      %{ conn | assigns: %{} }
    end
  end
end
