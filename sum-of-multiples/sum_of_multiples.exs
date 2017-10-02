defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    1..(limit - 1)
    |> Enum.filter(fn(x) -> is_factor?(x, factors) end)
    |> Enum.reduce(0, &(&1 + &2))
  end

  defp is_factor?(_, []) do
    false
  end
  defp is_factor?(x, [factor | rest]) do
    if rem(x, factor) == 0 do
      true
    else
      is_factor?(x, rest)
    end
  end
end
