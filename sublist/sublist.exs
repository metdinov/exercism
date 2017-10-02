defmodule Sublist do
  @type partial_order :: :equal | :unequal | :sublist | :superlist

  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  @spec compare(list, list) :: partial_order
  def compare(a, a),
    do: :equal
  def compare(a, b) when length(a) == length(b),
    do: :unequal
  def compare(a, b) when length(a) < length(b),
    do: if contains?(a, b), do: :sublist, else: :unequal
  def compare(a, b),
    do: if contains?(b, a), do: :superlist, else: :unequal
  

  @doc """
  Helper function that returns :true if list `b` contains list `a`
  """
  @spec contains?(list, list) :: boolean
  defp contains?(a, b) when length(b) >= length(a) do
    if Enum.take(b, length(a)) === a do
      true
    else
      contains?(a, tl(b))
    end
  end
  defp contains?(_, _) do
    false
  end
end
