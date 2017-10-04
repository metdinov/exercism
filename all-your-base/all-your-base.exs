defmodule AllYourBase do
  @doc """
  Given a number in base a, represented as a sequence of digits, converts it to base b,
  or returns nil if either of the bases are less than 2
  """

  @spec convert(list, integer, integer) :: list
  def convert(digits, base_a, base_b) do
    if valid_arguments?(digits, base_a, base_b) do
      digits
      |> to_base10(base_a)
      |> change_base(base_b)
    else
      nil
    end
  end

  @spec valid_arguments?(list(integer), integer, integer) :: boolean
  defp valid_arguments?(_, a, b) when a < 2 or b < 2, do: false
  defp valid_arguments?([], _, _), do: false
  defp valid_arguments?(digits, base, _), do: Enum.all?(digits, fn(x) -> x >= 0 and x < base end)

  # Helper function that a list of digits in base `base` and returns a number in base 10
  @spec to_base10(list(integer), integer) :: list(integer)
  defp to_base10(digits, base) do
    digits
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.reduce(0, fn({d, exp}, acc) -> acc + d * round(:math.pow(base, exp)) end)
  end

  # Helper function that takes and integer in base 10 and returns a list of digits of
  # its representation in base `base`
  @spec change_base(integer, integer, list(integer)) :: list(integer)
  defp change_base(x, base, digits \\ [])
  defp change_base(0, _, []) do
    [0]
  end
  defp change_base(0, _, digits) do
    digits
  end
  defp change_base(x, base, digits) do
    change_base(div(x, base), base, [rem(x, base) | digits])
  end
end
