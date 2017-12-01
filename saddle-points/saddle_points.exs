defmodule SaddlePoints do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    str
    |> String.split("\n")
    |> Enum.map(&to_int_list/1)
  end

  @spec to_int_list(String.t()) :: [integer]
  defp to_int_list(row) do
    row
    |> String.split
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    str
    |> rows
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    row_list = rows(str)
    column_list = columns(str)
    points =
      for {row, index} <- Enum.with_index(row_list) do
        for i <- index_of_func(row, &Enum.max/1) do
          for j <- index_of_func(Enum.at(column_list, i), &Enum.min/1),
              j == index,
              do: {index, i}
        end
      end
    List.flatten points
  end

  defp index_of_func(int_list, func) do
    value = func.(int_list)
    int_list
    |> Enum.with_index
    |> Enum.filter_map(fn {x, _} -> x == value end, fn {_, i} -> i end)
  end
end
