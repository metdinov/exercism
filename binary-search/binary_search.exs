defmodule BinarySearch do
  @doc """
    Searches for a key in the tuple using the binary search algorithm.
    It returns :not_found if the key is not in the tuple.
    Otherwise returns {:ok, index}.

    ## Examples

      iex> BinarySearch.search({}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 2)
      :not_found

      iex> BinarySearch.search({1, 3, 5}, 5)
      {:ok, 2}

  """

  @spec search(tuple, integer) :: {:ok, integer} | :not_found
  def search({}, _key) do
    :not_found
  end
  def search(numbers, key) do
    bsearch(numbers, 0, tuple_size(numbers) - 1, key)
  end

  defp bsearch(numbers, start, start, key) do
    if elem(numbers, start) == key do
      {:ok, start}
    else
      :not_found
    end
  end
  defp bsearch(numbers, start, stop, key) do
    bisect = div(stop - start, 2) + start
    cond do
      key == elem(numbers, bisect) -> {:ok, bisect}
      key < elem(numbers, bisect) -> bsearch(numbers, start, bisect, key)
      true -> bsearch(numbers, bisect + 1, stop, key)
    end
  end
end
