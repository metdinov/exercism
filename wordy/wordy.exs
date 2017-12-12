defmodule Wordy do

  @doc """
  Calculate the math problem in the sentence.
  """
  @spec answer(String.t) :: integer
  def answer("What is " <> sentence) do
    sentence
    |> String.replace(~r/\?|by|power/, "")
    |> String.split
    |> parse
  end
  def answer(_sentence), do: raise ArgumentError

  defp parse(sentence, acc \\ 0)
  defp parse([], acc), 
    do: acc
  defp parse(["plus", num | tail], acc), 
    do: parse(tail, acc + String.to_integer(num))
  defp parse(["minus", num | tail], acc), 
    do: parse(tail, acc - String.to_integer(num))
  defp parse(["multiplied", num | tail], acc), 
    do: parse(tail, acc * String.to_integer(num))
  defp parse(["divided", num | tail], acc), 
    do: parse(tail, div(acc, String.to_integer(num)))
  defp parse(["raised", "to", "the", num | tail], acc) do
    with {exp, _} <- Integer.parse(num) do
      parse(tail, round(:math.pow(acc, exp)))
    else
      :error -> raise ArgumentError
    end
  end
  defp parse([head | tail], _acc) do
    with {num, _} <- Integer.parse(head) do
      parse(tail, num)
    else
      :error -> raise ArgumentError
    end
  end
end
