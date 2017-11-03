defmodule Binary do
  @doc """
  Convert a string containing a binary number to an integer.

  On errors returns 0.
  """
  @spec to_decimal(String.t) :: non_neg_integer
  def to_decimal(string) do
    convert(string, String.length(string) - 1, 0)
  end

  defp convert("1" <> rest, exp, result),
    do: convert(rest, exp - 1, result + round(:math.pow(2, exp)))
  defp convert("0" <> rest, exp, result),
    do: convert(rest, exp - 1, result)
  defp convert("", _exp, result),
    do: result
  defp convert(_other, _exp, _result),
    do: 0
end
