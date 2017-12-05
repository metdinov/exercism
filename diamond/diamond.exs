defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t
  def build_shape(letter) when letter in ?A..?Z do
    builder(letter, 2 * (letter - ?A) + 1, 0, "")
  end

  defp builder(_letter, width, width, diamond),
    do: diamond
  defp builder(letter, width, line_number, diamond) do
    char =  if line_number > letter - ?A do
              2 * letter - ?A - line_number
            else
              ?A + line_number
            end
    pos = letter - char + 1
    line =  for i <- 1..width, into: "" do
              if i == pos or i == width - pos + 1 do
                <<char>>
              else
                " "
              end
            end
    builder(letter, width, line_number + 1, diamond <> line <> "\n")
  end
end
