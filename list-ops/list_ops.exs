defmodule ListOps do
  # Please don't use any external modules (especially List) in your
  # implementation. The point of this exercise is to create these basic functions
  # yourself.
  #
  # Note that `++` is a function from an external module (Kernel, which is
  # automatically imported) and so shouldn't be used either.

  @spec count(list) :: non_neg_integer
  def count(l), do: _count(l)

  @spec _count(list, non_neg_integer) :: non_neg_integer
  defp _count(l, len \\ 0)
  defp _count([], len), do: len
  defp _count([_ | tail], len), do: _count(tail, len + 1)

  @spec reverse(list) :: list
  def reverse(l), do: _reverse(l)

  @spec _reverse(list, list) :: list
  defp _reverse(l, rev \\ [])
  defp _reverse([], rev), do: rev
  defp _reverse([head | tail], rev), do: _reverse(tail, [head | rev])

  @spec map(list, (any -> any)) :: list
  def map(l, f), do: _map(l, f)

  @spec _map(list, (any -> any), list) :: list
  defp _map(l, fun, mapped \\ [])
  defp _map([], _fun, mapped), do: reverse(mapped)
  defp _map([head | tail], fun, mapped), do: _map(tail, fun, [fun.(head) | mapped])

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: _filter(l, f)

  @spec _filter(list, (any -> as_boolean(term)), list) :: list
  defp _filter(l, fun, filtered \\ [])
  defp _filter([], _fun, filtered) do
    reverse(filtered)
  end
  defp _filter([head | tail], fun, filtered) do
    if fun.(head) do
      _filter(tail, fun, [head | filtered])
    else
      _filter(tail, fun, filtered)
    end
  end

  @type acc :: any
  @spec reduce(list, acc, ((any, acc) -> acc)) :: acc
  def reduce([], acc, _), do: acc
  def reduce([head | tail], acc, f), do: reduce(tail, f.(head, acc), f)

  @spec append(list, list) :: list
  def append(a, b), do: _stack(reverse(a), b)

  # Stacks the elements of a onto b. Same as Enum.reverse(a) ++ b
  @spec _stack(list, list) :: list
  defp _stack([], b), do: b
  defp _stack([head | tail], b), do: _stack(tail, [head | b])

  @spec concat([[any]]) :: [any]
  def concat(ll), do: _concat(reverse(ll))

  @spec _concat([[any]], list) :: [any]
  defp _concat(ll, builder \\ [])
  defp _concat([], builder), do: builder
  defp _concat([head | tail], builder), do: _concat(tail, append(head, builder))
end
