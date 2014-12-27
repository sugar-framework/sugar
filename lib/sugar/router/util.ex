defmodule Sugar.Router.Util do
  @moduledoc false

  defmodule InvalidSpecError do
    @moduledoc false
    defexception message: "invalid route specification"
  end

  @spec normalize_method(atom) :: binary
  def normalize_method(method) do
    method |> to_string |> String.upcase
  end

  @spec split(binary) :: [binary]
  def split(bin) do
    for segment <- String.split(bin, "/"), segment != "", do: segment
  end

  @spec build_spec(binary | any, nil) :: any
  def build_spec(spec, context \\ nil)
  def build_spec(spec, context) when is_binary(spec) do
    build_spec split(spec), context, [], []
  end
  def build_spec(spec, _context) do
    {[], spec}
  end
  defp build_spec([h|t], context, vars, acc) do
    handle_segment_match segment_match(h, "", context), t, context, vars, acc
  end
  defp build_spec([], _context, vars, acc) do
    {vars |> Enum.uniq |> Enum.reverse, Enum.reverse(acc)}
  end

  defp handle_segment_match({:literal, literal}, t, context, vars, acc) do
    build_spec t, context, vars, [literal|acc]
  end
  defp handle_segment_match({:identifier, identifier, expr}, t, context, vars, acc) do
    build_spec t, context, [identifier|vars], [expr|acc]
  end
  defp handle_segment_match({:glob, identifier, expr}, t, context, vars, acc) do
    if t != [] do
      raise InvalidSpecError, message: "cannot have a *glob followed by other segments"
    end

    case acc do
      [hs|ts] ->
        acc = [{:|, [], [hs, expr]} | ts]
        build_spec([], context, [identifier|vars], acc)
      _ ->
        {vars, expr} = build_spec([], context, [identifier|vars], [expr])
        {vars, hd(expr)}
    end
  end

  defp segment_match(":" <> argument, buffer, context) do
    identifier = binary_to_identifier(":", argument)
    expr = quote_if_buffer identifier, buffer, context, fn var ->
      quote do: unquote(buffer) <> unquote(var)
    end
    {:identifier, identifier, expr}
  end
  defp segment_match("*" <> argument, buffer, context) do
    underscore = {:_, [], context}
    identifier = binary_to_identifier("*", argument)
    expr = quote_if_buffer identifier, buffer, context, fn var ->
      quote do: [unquote(buffer) <> unquote(underscore)|unquote(underscore)] = unquote(var)
    end
    {:glob, identifier, expr}
  end
  defp segment_match(<<h, t::binary>>, buffer, context) do
    segment_match t, buffer <> <<h>>, context
  end
  defp segment_match(<<>>, buffer, _context) do
    {:literal, buffer}
  end

  defp quote_if_buffer(identifier, "", context, _fun) do
    {identifier, [], context}
  end
  defp quote_if_buffer(identifier, _buffer, context, fun) do
    fun.({identifier, [], context})
  end

  defp binary_to_identifier(prefix, <<letter, _::binary>> = binary) when letter in ?a..?z
                                                                      or letter == ?_ do
    if binary =~ ~r/^\w+$/ do
      String.to_atom(binary)
    else
      raise InvalidSpecError, message: "#{prefix}identifier in routes must be made of letters, numbers and underscore"
    end
  end
  defp binary_to_identifier(prefix, _) do
    raise InvalidSpecError, message: "#{prefix} in routes must be followed by lowercase letters"
  end
end