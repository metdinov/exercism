defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t) :: boolean
  def isogram?(sentence) do
    sentence
    |> String.replace(~r/[^\w]/, "")
    |> _isogram?
  end

  defp _isogram?(""), do: true
  defp _isogram?(<<_char::utf8>>), do: true
  defp _isogram?(<<char::utf8, rest::binary>>) do
    if String.contains?(rest, <<char>>) do
      false
    else
      _isogram?(rest)
    end
  end
end
