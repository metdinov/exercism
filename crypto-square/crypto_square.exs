defmodule CryptoSquare do
  
  @doc """
  Encode string square methods
  ## Examples

    iex> CryptoSquare.encode("abcd")
    "ac bd"
  """
  @spec encode(String.t) :: String.t
  def encode("") do
    ""
  end
  def encode(str) do
    normalized = 
      str
      |> String.downcase
      |> String.replace(~r/[^a-z0-9]/, "")

    c = String.length(normalized) |> :math.sqrt |> :math.ceil |> round

    codewords = for row <- 0..(c-1), 
                  do: take_every_nth_char(String.slice(normalized, row..-1), c)
    Enum.join(codewords, " ")
  end

  defp take_every_nth_char(str, n, acc \\ [])
  defp take_every_nth_char("", _n, acc),
    do: acc |> Enum.reverse |> Enum.join
  defp take_every_nth_char(str, n, acc),
    do: take_every_nth_char(String.slice(str, n..-1), n, [String.at(str, 0) | acc])
end
