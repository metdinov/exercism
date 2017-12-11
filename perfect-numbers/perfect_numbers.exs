defmodule PerfectNumbers do
  @doc """
  Determine the aliquot sum of the given `number`, by summing all the factors
  of `number`, aside from `number` itself.

  Based on this sum, classify the number as:

  :perfect if the aliquot sum is equal to `number`
  :abundant if the aliquot sum is greater than `number`
  :deficient if the aliquot sum is less than `number`
  """
  @spec classify(number :: integer) :: ({ :ok, atom } | { :error, String.t() })
  def classify(number) when number <= 0 do
    {:error, "Classification is only possible for natural numbers."}
  end
  def classify(1) do
    {:ok, :deficient}
  end
  def classify(number) do
    1..(round(number / 2))
    |> Enum.filter(&factor?(number, &1))
    |> Enum.reduce(&+/2)
    |> classify_sum(number)
  end

  defp classify_sum(sum, number) when sum == number, do: {:ok, :perfect}
  defp classify_sum(sum, number) when sum < number, do: {:ok, :deficient}
  defp classify_sum(_sum, _number), do: {:ok, :abundant}

  @spec factor?(integer, integer) :: boolean
  defp factor?(a, b), do: rem(a, b) == 0
end

