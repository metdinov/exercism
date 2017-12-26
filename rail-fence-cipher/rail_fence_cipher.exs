defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t, pos_integer) :: String.t
  def encode(str, 1) do
    str
  end
  def encode(str, rails) do
    fence = 
      Enum.concat((1..rails), (rails-1)..2)
      |> Stream.cycle
      |> Enum.take(String.length(str))

    str
    |> build_rails(fence)
    |> Enum.join   
  end

  def build_rails(str, fence, acc \\ [])
  def build_rails("", _fence, acc),
    do: acc |> Enum.map(&Enum.reverse/1) |> Enum.map(&Enum.join/1)
  def build_rails(<<char::utf8, rest::binary>>, [rail | fence], acc) when length(acc) >= rail,
    do: build_rails(rest, fence, List.update_at(acc, rail - 1, fn chars -> [<<char>> | chars] end))
  def build_rails(<<char::utf8, rest::binary>>, [_rail | fence], acc),
    do: build_rails(rest, fence, acc ++ [[<<char>>]])

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t, pos_integer) :: String.t
  def decode(str, rails) do
    str
  end
end
