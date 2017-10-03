defmodule Anagram do
  import String, only: [downcase: 1, graphemes: 1]
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t, [String.t]) :: [String.t]
  def match(base, candidates) do
     for word <- candidates, is_anagram?(word, base), do: word
  end

  defp is_anagram?(a, b) do
    downcase(a) != downcase(b) and sort_string(a) == sort_string(b)
  end

  defp sort_string(str) do
    str
    |> downcase
    |> graphemes
    |> Enum.sort
  end
end
