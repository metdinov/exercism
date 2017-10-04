defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: non_neg_integer
  def hamming_distance(strand1, strand2) when length(strand1) != length(strand2) do
    {:error, "Lists must be the same length"}
  end
  def hamming_distance(strand1, strand2) do
    {:ok, count_mutations(strand1, strand2)}
  end

  @spec count_mutations([char], [char], non_neg_integer) :: non_neg_integer
  defp count_mutations(strand1, strand2, count \\ 0)
  defp count_mutations([], [], count),
    do: count
  defp count_mutations([nucleotide | strand1], [nucleotide | strand2], count),
    do: count_mutations(strand1, strand2, count)
  defp count_mutations([_ | strand1], [_ | strand2], count),
    do: count_mutations(strand1, strand2, count + 1)
end
