defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    for <<char <- text>>, into: "", do: shifter(char, shift)
  end

  defp shifter(char, s) when char in ?A..?Z, do: <<?A + rem(char + s - ?A, 26)>>
  defp shifter(char, s) when char in ?a..?z, do: <<?a + rem(char + s - ?a, 26)>>
  defp shifter(char, s), do: <<char>>
end

