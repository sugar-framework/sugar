defmodule Sugar.Controller do
  import Plug.Conn
  @moduledoc """
  All controller actions should have an arrity of 2, with the
  first argument being a `Plug.Conn` representing the current
  connection and the second argument being a `Keyword` list
  of any parameters captured in the route path.

  Sugar bundles these response helpers to assist in sending a
  response:

  * `render/4` - `conn`, `template_key`, `assigns`, `opts` - sends a normal
    response.
  * `halt!/2` - `conn`, `opts` - ends the response.
  * `not_found/1` - `conn`, `message` - sends a 404 (Not found) response.
  * `json/2` - `conn`, `data` - sends a normal response with
    `data` encoded as JSON.
  * `raw/1` - `conn` - sends response as-is. It is expected
    that status codes, headers, body, etc have been set by
    the controller action.
  * `static/2` - `conn`, `file` - reads and renders a single static file.

  #### Example

      defmodule Hello do
        use Sugar.Controller

        def index(conn, []) do
          render conn, "showing index controller"
        end

        def show(conn, args) do
          render conn, "showing page \#{args[:id]}"
        end

        def create(conn, []) do
          render conn, "page created"
        end

        def get_json(conn, []) do
          json conn, [message: "foobar"]
        end
      end
  """

  @doc """
  Macro used to add necessary items to a controller.
  """
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      import unquote(Plug.Conn)
      use unquote(Sugar.Controller.Hooks)
    end
  end

  @doc """
  sets connection status

  ## Arguments

  * `conn` - `Plug.Conn`
  * `status_code` - `Integer`

  ## Returns

  `Plug.Conn`
  """
  def status(conn, status_code) do
    %Plug.Conn{conn | status: status_code, state: :set}
  end

  @doc """
  sets response headers

  ## Arguments

  * `conn` - `Plug.Conn`
  * `status_code` - `Integer`

  ## Returns

  `Plug.Conn`
  """
  def headers(conn, headers) do
    %Plug.Conn{conn | resp_headers: headers, state: :set}
  end

  @doc """
  reads and renders a single static file.

  ## Arguments

  * `conn` - `Plug.Conn`
  * `file` - `String`

  ## Returns

  `Plug.Conn`
  """
  def static(conn, file) do
    filename = Path.join(["priv/static", file])
    if File.exists? filename do
      body = filename |> File.read!
      conn
        |> put_resp_content_type_if_not_sent("text/html")
        |> send_resp_if_not_sent(200, body)
    else
      conn
        |> not_found
    end
  end

  @doc """
  Sends a normal response with `data` encoded as JSON.

  ## Arguments

  * `conn` - `Plug.Conn`
  * `data` - `Keyword|List`

  ## Returns

  `Plug.Conn`
  """
  def json(conn, data, opts) do
    opts = [status: 200] |> Keyword.merge opts
    conn
      |> put_resp_content_type_if_not_sent("application/json")
      |> send_resp_if_not_sent(opts[:status], JSEX.encode! data)
  end
  def json(conn, data) do
    status = conn.status || 200
    if get_resp_header(conn, "content-type") == [] do
      conn = put_resp_content_type_if_not_sent(conn, "application/json")
    end
    conn |> send_resp_if_not_sent(status, JSEX.encode! data)
  end

  @doc """
  Sends response as-is. It is expected that status codes,
  headers, body, etc have been set by the controller
  action.

  ## Arguments

  * `conn` - `Plug.Conn`

  ## Returns

  `Plug.Conn`
  """
  def raw(conn) do
    conn |> send_resp
  end

  @doc """
  Sends a normal response. 

  Automatically renders a template based on the
  current controller and action names when no
  template is passed.

  ## Arguments

  * `conn` - `Plug.Conn`
  * `template_key` - `String`
  * `assigns` - `Keyword`
  * `opts` - `Keyword`

  ## Returns

  `Plug.Conn`
  """
  def render(conn, template \\ nil, assigns \\ [], opts \\ [])
  def render(conn, template, assigns, opts) when is_atom(template)
                                              or is_binary(template) do
    template = build_template_key(conn, template)
    render_view(conn, template, assigns, opts)
  end
  def render(conn, assigns, opts, _) when is_list(assigns) do
    template = build_template_key(conn)
    render_view(conn, template, assigns, opts)
  end

  defp render_view(conn, template_key, assigns, opts) do
    opts = [status: 200] |> Keyword.merge opts

    html = Sugar.Config.get(:sugar, :views_dir, "lib/#{Mix.Project.config[:app]}/views")
      |> Sugar.Views.Finder.one(template_key)
      |> Sugar.Templates.render(assigns)

    conn
      |> put_resp_content_type_if_not_sent(opts[:content_type] || "text/html")
      |> send_resp_if_not_sent(opts[:status], html)
  end

  @doc """
  Ends the response.

  ## Arguments

  * `conn` - `Plug.Conn`
  * `opts` - `Keyword`

  ## Returns

  `Plug.Conn`
  """
  def halt!(conn, opts \\ []) do
    opts = [status: 401, message: ""] |> Keyword.merge opts
    conn
      |> send_resp_if_not_sent(opts[:status], opts[:message])
  end

  @doc """
  Sends a 404 (Not found) response.

  ## Arguments

  * `conn` - `Plug.Conn`

  ## Returns

  `Plug.Conn`
  """
  def not_found(conn, message \\ "Not Found") do
    conn
      |> send_resp_if_not_sent(404, message)
  end

  @doc """
  Forwards the response to another controller action.

  ## Arguments

  * `conn` - `Plug.Conn`
  * `controller` - `Atom`
  * `action` - `Atom`
  * `args` - `Keyword`

  ## Returns

  `Plug.Conn`
  """
  def forward(conn, controller, action, args \\ []) do
    apply controller, action, [conn, args]
  end

  @doc """
  Redirects the response.

  ## Arguments

  * `conn` - `Plug.Conn`
  * `location` - `String`
  * `opts` - `Keyword`

  ## Returns

  `Plug.Conn`
  """
  def redirect(conn, location, opts \\ []) do
    opts = [status: 302] |> Keyword.merge opts
    conn
      |> put_resp_header_if_not_sent("Location", location)
      |> send_resp_if_not_sent(opts[:status], "")
  end

  defp build_template_key(conn, template \\ nil) do
    default = Map.get(conn.private, :action) || :index
    template = template || default

    controller = "#{Map.get(conn.private, :controller, "")}"
                  |> String.split(".")
                  |> List.last
                  |> String.downcase

     "#{controller}/#{template}"
  end

  defp put_resp_header_if_not_sent(%Plug.Conn{state: :sent} = conn, _, _) do
    conn
  end
  defp put_resp_header_if_not_sent(conn, key, value) do
    conn |> put_resp_header(key, value)
  end

  defp put_resp_content_type_if_not_sent(%Plug.Conn{state: :sent} = conn, _) do
    conn
  end
  defp put_resp_content_type_if_not_sent(conn, resp_content_type) do
    conn |> put_resp_content_type(resp_content_type)
  end

  defp send_resp_if_not_sent(%Plug.Conn{state: :sent} = conn, _, _) do
    conn
  end
  defp send_resp_if_not_sent(conn, status, body) do
    conn |> send_resp(status, body)
  end
end
