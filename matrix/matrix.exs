defmodule Matrix do
  defstruct matrix: nil

  @doc """
  Convert an `input` string, with rows separated by newlines and values
  separated by single spaces, into a `Matrix` struct.
  """
  @spec from_string(input :: String.t()) :: %Matrix{}
  def from_string(input) do
    matrix =
      input
      |> String.split("\n")
      |> Enum.map(&read_row/1)

    %Matrix{matrix: matrix}
  end

  defp read_row(str) do
    str
    |> String.split
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Write the `matrix` out as a string, with rows separated by newlines and
  values separated by single spaces.
  """
  @spec to_string(matrix :: %Matrix{}) :: String.t()
  def to_string(matrix) do
    str =
      for numbers <- matrix.matrix, into: "" do
        Enum.join(numbers, " ") <> "\n"
      end
    
    String.trim_trailing(str)
  end

  @doc """
  Given a `matrix`, return its rows as a list of lists of integers.
  """
  @spec rows(matrix :: %Matrix{}) :: list(list(integer))
  def rows(matrix) do
    matrix.matrix
  end

  @doc """
  Given a `matrix` and `index`, return the row at `index`.
  """
  @spec row(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def row(matrix, index) do
    Enum.at(matrix.matrix, index)
  end

  @doc """
  Given a `matrix`, return its columns as a list of lists of integers.
  """
  @spec columns(matrix :: %Matrix{}) :: list(list(integer))
  def columns(matrix) do
    num_columns = matrix.matrix |> hd |> length
    for index <- 0..(num_columns - 1), do: column(matrix, index)
  end

  @doc """
  Given a `matrix` and `index`, return the column at `index`.
  """
  @spec column(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def column(matrix, index) do
    num_rows = length(matrix.matrix)
    for i <- 0..(num_rows - 1) do
      matrix.matrix
      |> Enum.at(i)
      |> Enum.at(index)
    end
  end
end

