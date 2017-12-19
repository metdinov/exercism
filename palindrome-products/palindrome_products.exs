defmodule Palindromes do

  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1) do
    products = for  i <- min_factor..max_factor,
                    j <- i..max_factor,
                    palindrome?(i * j),
                    do: [i, j]
    Enum.group_by(products, fn [i, j] -> i * j end)
  end

  def palindrome?(n) when is_integer(n), do: palindrome?(Integer.digits(n))
  def palindrome?(digits), do: digits == Enum.reverse(digits)
end
