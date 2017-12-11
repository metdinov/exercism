defmodule Sieve do

  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
    2..limit
    |> Enum.to_list
    |> do_sieve
  end

  defp do_sieve([head | tail]) do
    [head | do_sieve(Enum.filter(tail, fn x -> rem(x, head) != 0 end))]
  end
  defp do_sieve([]) do
    []
  end
end
