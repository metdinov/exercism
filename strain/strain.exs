defmodule Strain do
  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns true.

  Do not use `Enum.filter`.

  Second version using tail recursion
  """
  @spec keep(list :: list(any), fun :: ((any) -> boolean)) :: list(any)
  def keep(list, fun) do
    recurse(list, fun, [])
  end

  defp recurse([head | tail], fun, result) do
    if fun.(head) do
      recurse(tail, fun, [head | result])
    else
      recurse(tail, fun, result)
    end
  end
  defp recurse([], fun, result), do: result |> Enum.reverse

  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns false.

  Do not use `Enum.reject`.
  """
  @spec discard(list :: list(any), fun :: ((any) -> boolean)) :: list(any)
  def discard(list, fun) do
    keep(list, fn x -> not fun.(x) end)
  end
end
