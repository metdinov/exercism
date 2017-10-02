defmodule RunLengthEncoder do
  @moduledoc """
  Run-length encoding (RLE) is a simple form of data compression, where runs 
  (consecutive data elements) are replaced by just one data value and count.

  __Look Ma! No regexes!__
  """

  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t) :: String.t
  def encode(string) do
    string
    |> encoder
    |> Enum.reverse
    |> Enum.join("")
  end

  defp encoder(string, count \\ 1, encoding \\ [])
  defp encoder(<<>>, _, encoding) do
    encoding
  end
  defp encoder(<<char::utf8, rest::binary>>, count, encoding) do
    case rest do
      <<^char, _::binary>> -> encoder(rest, count + 1, encoding)
      <<>> -> [make_code(char, count) | encoding]
      _ -> encoder(rest, 1, [make_code(char, count) | encoding])
    end
  end

  defp make_code(char, 1), do: <<char>>
  defp make_code(char, count), do: to_string(count) <> <<char>>

  @spec decode(String.t) :: String.t
  def decode(string) do
    string
    |> decoder
    |> Enum.reverse
    |> Enum.join("")
  end

  defp decoder(string, count \\ 0, encoding \\ [])
  defp decoder(<<>>, _, encoding) do
    encoding
  end
  defp decoder(<<char::utf8, rest::binary>>, count, encoding) do
    cond do
      char in ?0..?9 -> decoder(rest, count * 10 + char - ?0, encoding)
      count == 0 -> decoder(rest, 0, [<<char>> | encoding])
      true -> decoder(rest, 0, [String.duplicate(<<char>>, count) | encoding])
    end
  end
end
