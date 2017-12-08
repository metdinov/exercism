defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number),
    do: factorize(number, 2)
  
  defp factorize(1, _factor),
    do: []
  defp factorize(number, 2) when rem(number, 2) != 0,
    do: factorize(number, 3)
  defp factorize(number, factor) when rem(number, factor) == 0,
    do: [factor | factorize(div(number, factor), factor)]
  defp factorize(number, factor),
    do: factorize(number, factor + 2)
end
