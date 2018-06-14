defmodule Minesweeper do
  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t()]) :: [String.t()]

  def annotate([]) do
    []
  end
  def annotate(board) do
    for row <- 0..length(board)-1 do
      build_row(row, board)
    end
  end

  defp build_row(row, board) do
    n_cols = String.length(Enum.at(board, 0))
    n_rows = length(board)

    for col <- 0..n_cols-1,
        into: "" do
        if String.at(Enum.at(board, row), col) == "*" do
          "*"
        else
          board
          |> Enum.slice(max(0, row-1)..min(n_rows-1, row+1))
          |> Enum.map(&String.slice(&1, max(0, col-1)..min(n_cols-1, col+1)))
          |> Enum.map(&count_mines/1)
          |> Enum.sum
          |> to_str
        end
    end
  end

  defp count_mines(str, acc \\ 0)
  defp count_mines("*" <> rest, acc), do: count_mines(rest, acc + 1)
  defp count_mines("", acc), do: acc
  defp count_mines(<<_char::utf8, rest::binary>>, acc), do: count_mines(rest, acc)

  defp to_str(0), do: " "
  defp to_str(n) when is_integer(n), do: Integer.to_string(n)
end
