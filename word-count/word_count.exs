defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t) :: map
  def count(sentence) do
    sentence
    |> String.downcase
    |> (&Regex.scan(~r/[-0-9\p{L}]+/ui, &1)).() # \p{L} matches unicode letters
    |> Enum.reduce(%{}, fn([word], dict) -> Map.update(dict, word, 1, &(&1 + 1)) end)
  end
end
