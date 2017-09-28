defmodule StringSeries do
  @doc """
  Given a string `s` and a positive integer `size`, return all substrings
  of that size. If `size` is greater than the length of `s`, or less than 1,
  return an empty list.
  """
  @spec slices(s :: String.t(), size :: integer) :: list(String.t())
  def slices(_s, _size) do
    if (String.length(_s) < _size) or (_size <= 0) do
      []
    else
      for i <- 0..(String.length(_s) - _size), do: String.slice(_s, i..(i + _size - 1))
    end
  end
end

