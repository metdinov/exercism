defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t, pos_integer) :: String.t
  def encode(str, 1) do
    str
  end
  def encode(str, rails) do
    fence = build_fence(rails, String.length(str))

    for rail <- 1..rails,
        indices = find_indices(fence, rail),
        into: "" do
          for ind <- indices, into: "", do: String.at(str, ind)      
    end
  end

  defp build_fence(rails, len) do
    Enum.concat((1..rails), (rails-1)..2)
    |> Stream.cycle
    |> Enum.take(len)
  end

  # Helper function (Enum.find_index stops at first match)
  defp find_indices(list, value) do
    list
    |> Enum.with_index
    |> Enum.filter(fn {x, _} -> x == value end)
    |> Enum.map(fn {_, i} -> i end)
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t, pos_integer) :: String.t
  def decode(str, 1) do
    str
  end
  def decode(str, rails) do
    rails
    |> build_fence(String.length(str))
    |> Enum.with_index
    |> Enum.sort
    |> Enum.zip(String.graphemes(str))
    |> Enum.sort_by(fn {{_rail, i}, _char} -> i end)
    |> Enum.map(fn {{_rail, _i}, char} -> char end)
    |> Enum.join
  end
end
