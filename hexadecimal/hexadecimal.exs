defmodule Hexadecimal do
  @doc """
    Accept a string representing a hexadecimal value and returns the
    corresponding decimal value.
    It returns the integer 0 if the hexadecimal is invalid.
    Otherwise returns an integer representing the decimal value.

    ## Examples

      iex> Hexadecimal.to_decimal("invalid")
      0

      iex> Hexadecimal.to_decimal("af")
      175

  """

  @spec to_decimal(binary) :: integer
  def to_decimal(hex) do
    hex
    |> String.downcase
    |> from_hex
    |> round
  end

  defp from_hex(str),
    do: from_hex(str, String.length(str) - 1, 0)
  defp from_hex(<<c::utf8, rest::binary>>, exp, acc) when c in ?a..?f do
    from_hex(rest, exp - 1, acc + (c - ?a + 10) * :math.pow(16, exp))
  end
  defp from_hex(<<c::utf8, rest::binary>>, exp, acc) when c in ?0..?9,
    do: from_hex(rest, exp - 1, acc + (c - ?0) * :math.pow(16, exp))
  defp from_hex(<<>>, _exp, acc),
    do: acc
  defp from_hex(_str, _exp, _acc),
    do: 0
end
