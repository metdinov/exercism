defmodule LinkedList do
  @opaque t :: tuple()

  @doc """
  Construct a new LinkedList
  """
  @spec new() :: t
  def new() do
    {}
  end

  @doc """
  Push an item onto a LinkedList
  """
  @spec push(t, any()) :: t
  def push(list, elem) do
    {elem, list}
  end

  @doc """
  Calculate the length of a LinkedList
  """
  @spec length(t) :: non_neg_integer()
  def length(list) do
    _length(list, 0)
  end

  defp _length({}, size), do: size
  defp _length({_, list}, size), do: _length(list, size + 1)

  @doc """
  Determine if a LinkedList is empty
  """
  @spec empty?(t) :: boolean()
  def empty?(list) do
    list === new()
  end

  @doc """
  Get the value of a head of the LinkedList
  """
  @spec peek(t) :: {:ok, any()} | {:error, :empty_list}
  def peek({}), do: {:error, :empty_list}
  def peek({elem, _}), do: {:ok, elem}

  @doc """
  Get tail of a LinkedList
  """
  @spec tail(t) :: {:ok, t} | {:error, :empty_list}
  def tail({}), do: {:error, :empty_list}
  def tail({_, list}), do: {:ok, list}

  @doc """
  Remove the head from a LinkedList
  """
  @spec pop(t) :: {:ok, any(), t} | {:error, :empty_list}
  def pop({}), do: {:error, :empty_list}
  def pop({elem, list}), do: {:ok, elem, list}

  @doc """
  Construct a LinkedList from a stdlib List
  """
  @spec from_list(list()) :: t
  def from_list(list) do
    list
    |> Enum.reverse
    |> _from_list(new())
  end

  defp _from_list([], builder), do: builder
  defp _from_list([head | rest], builder), do: _from_list(rest, push(builder, head))

  @doc """
  Construct a stdlib List LinkedList from a LinkedList
  """
  @spec to_list(t) :: list()
  def to_list(list) do
    list
    |> _to_list([])
    |> Enum.reverse
  end

  defp _to_list({}, builder), do: builder
  defp _to_list({elem, list}, builder), do: _to_list(list, [elem | builder])

  @doc """
  Reverse a LinkedList
  """
  @spec reverse(t) :: t
  def reverse(list) do
    _reverse(list, new())
  end

  defp _reverse({}, builder), do: builder
  defp _reverse({elem, list}, builder), do: _reverse(list, push(builder, elem))
end
