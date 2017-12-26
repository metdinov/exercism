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

    for rail <- 1..rails,
        indeces = Enum.filter(Enum.with_index(fence), fn {i, _} -> i == rail end),
        into: "",
        do: for {_rail, ind} <- indeces, into: "", do: String.at(str, ind)
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t, pos_integer) :: String.t
  def decode(str, rails) do
    str
  end
end
