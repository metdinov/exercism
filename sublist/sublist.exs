defmodule Sublist do
  @type partial_order :: :equal | :unequal | :sublist | :superlist

  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  @spec compare(list, list) :: partial_order
  def compare(a, b) do
    cond do
      length(a) < length(b) -> contains?(a, b, :sublist)
      length(a) > length(b) -> contains?(b, a, :superlist)
      a === b -> :equal
      true -> :unequal
    end 
  end

  @doc """
  Helper function that returns `order` if list `b` contains list `a`
  """
  @spec contains?(list, list, partial_order, pos_integer) :: partial_order
  defp contains?(a, b, order, index \\ 0) do
    cond do
      length(b) - index < length(a) -> :unequal
      Enum.slice(b, index, length(a)) === a -> order
      true -> contains?(a, b, order, index + 1)
    end
  end
end
