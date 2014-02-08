defmodule Sugar.Controller do
  import Plug.Connection

  @doc """
  `__using__/1` macro used to add necessary items to a controller.
  """
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end

  def json(conn, data) do
    conn = conn
      |> put_resp_content_type(MIME.Types.type("json"))
      |> resp(200, JSEX.encode! data)
    {:ok, conn |> send_resp}
  end

  def raw(conn) do
    {:ok, conn |> send_resp}
  end

  def render(conn, template) do
    conn = conn 
      |> put_resp_content_type(MIME.Types.type("html")) 
      |> resp(200, template)
    {:ok, conn |> send_resp}
  end

  def halt!(conn) do
    {:ok, send_resp(conn, 401, "")}
  end

  def not_found(conn) do
    {:ok, send_resp(conn, 404, "Not Found")}
  end
end