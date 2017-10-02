defmodule Scrabble do
  @letter_scores  %{A: 1, E: 1, I: 1, O: 1, U: 1, L: 1, N: 1, R: 1, S: 1, T: 1,
                  D: 2, G: 2,
                  B: 3, C: 3, M: 3, P: 3,
                  F: 4, H: 4, V: 4, W: 4, Y: 4,
                  K: 5,
                  J: 8, X: 8,
                  Q: 10, Z: 10}

  @doc """
  Calculate the scrabble score for the word.
  """
  @spec score(String.t) :: non_neg_integer
  def score(word) do
    word
    |> String.replace(~r{\s}, "")
    |> String.upcase
    |> count_points(0)
  end

  defp count_points("", points) do
    points
  end
  defp count_points(<<letter::utf8, rest::binary>>, points) do
    count_points(rest, points + @letter_scores[String.to_atom(<<letter>>)])
  end
end
