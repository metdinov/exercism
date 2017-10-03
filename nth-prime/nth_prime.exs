defmodule Prime do

  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) when count < 1, do: raise ArgumentError, message: "invalid count #{count}"
  def nth(1), do: 2
  def nth(2), do: 3
  def nth(count), do: find_prime(count, [3, 2])

  defp find_prime(n, primes, current \\ 5)
  defp find_prime(n, primes, _) when length(primes) == n do
    hd(primes)
  end
  defp find_prime(n, primes, current) do
    if Enum.any?(primes, fn(x) -> rem(current, x) == 0 end) do
      find_prime(n, primes, current + 2)
    else
      find_prime(n, [current | primes], current + 2)
    end
  end
end
