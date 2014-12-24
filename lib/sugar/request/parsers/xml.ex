defmodule Sugar.Request.Parsers.XML do
  @moduledoc false
  alias Plug.Conn

  @types [ "application", "text" ]

  @type conn    :: map
  @type headers :: map
  @type opts    :: Keyword.t

  @spec parse(conn, binary, binary, headers, opts) :: {:ok | :error, map | atom, conn}
  def parse(%Conn{} = conn, type, "xml", _headers, opts) when type in @types do
    case Conn.read_body(conn, opts) do
      { :ok, body, conn } ->
        { :ok, %{ xml: body |> do_parse }, conn }
      { :more, _data, conn } ->
        { :error, :too_large, conn }
    end
  end
  def parse(conn, _type, _subtype, _headers, _opts) do
    { :next, conn }
  end

  defp do_parse(xml) do
    :erlang.bitstring_to_list(xml)
      |> :xmerl_scan.string
      |> elem(0)
      |> do_parse_nodes
  end

  defp do_parse_nodes([]), do: []
  defp do_parse_nodes([ h | t ]) do
    do_parse_nodes(h) ++ do_parse_nodes(t)
  end
  defp do_parse_nodes({ :xmlAttribute, name, _, _, _, _, _, _, value, _ }) do
    [ { name, value |> to_string } ]
  end
  defp do_parse_nodes({ :xmlElement, name, _, _, _, _, _, attrs, els, _, _, _ }) do
    value = els 
            |> do_parse_nodes 
            |> flatten
    [ %{ name: name, 
         attr: attrs |> do_parse_nodes, 
         value: value } ]
  end
  defp do_parse_nodes({ :xmlText, _, _, _, value, _ }) do
    string_value = value 
                   |> to_string 
                   |> String.strip
    if string_value |> String.length > 0 do
      [ string_value ]
    else
      []
    end
  end

  defp flatten([]), do: []
  defp flatten(values) do
    if Enum.all?(values, &(is_binary(&1))) do
      [ values |> List.to_string ]
    else
      values
    end
  end
end