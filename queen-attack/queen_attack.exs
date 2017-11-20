defmodule Queens do
  @type t :: %Queens{ black: {integer, integer}, white: {integer, integer} }
  defstruct black: nil, white: nil

  @empty_row ~w(_ _ _ _ _ _ _ _)

  @doc """
  Creates a new set of Queens
  """
  @spec new() :: Queens.t()
  def new do
    %Queens{black: {7, 3}, white: {0, 3}}
  end
  @spec new({integer, integer}, {integer, integer}) :: Queens.t()
  def new(queen, queen) do
    raise ArgumentError
  end
  def new(white, black) do
    %Queens{black: black, white: white}
  end

  @doc """
  Gives a string reprentation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(queens) do
    rows = Enum.map(0..7, &format_row(&1, queens.white, queens.black))
    Enum.join(rows, "\n")
  end

  defp format_row(row, {row, col_white}, {row, col_black}) do
    @empty_row
    |> List.replace_at(col_white, "W")
    |> List.replace_at(col_black, "B")
    |> Enum.join(" ")
  end
  defp format_row(row, {row, col_white}, _black_queen) do
    @empty_row
    |> List.replace_at(col_white, "W")
    |> Enum.join(" ")
  end
  defp format_row(row, _white_queen, {row, col_black}) do
    @empty_row
    |> List.replace_at(col_black, "B")
    |> Enum.join(" ")
  end
  defp format_row(_row, _white_queen, _black_queen) do
    Enum.join(@empty_row, " ")
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(queens) do
    elem(queens.black, 0) == elem(queens.white, 0) or
    elem(queens.black, 1) == elem(queens.white, 1) or
    (abs(elem(queens.black, 0) - elem(queens.white, 0)) ==
    abs(elem(queens.black, 1) - elem(queens.white, 1)))
  end
end
