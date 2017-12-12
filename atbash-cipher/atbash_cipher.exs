defmodule Atbash do
  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t) :: String.t
  def encode(plaintext) do
    plaintext
    |> String.downcase
    |> String.replace(~r/[^a-z0-9]/, "")
    |> encoder
    |> Enum.reverse
    |> Enum.join(" ")
  end

  defp encoder(plaintext, ciphertext \\ [])
  defp encoder("", ciphertext) do
    ciphertext
  end
  defp encoder(plaintext, ciphertext) do
    with {text, rest} <- String.split_at(plaintext, 5) do
      coded = for <<char::utf8 <- text>>, into: "", do: <<encode_char(char)>>
      encoder(rest, [coded | ciphertext])
    end
  end

  defp encode_char(char) when char in ?a..?z,
    do: ?a + rem((char - ?a) * (?z - ?a) + ?z - ?a, ?z - ?a + 1)
  defp encode_char(char),
    do: char
  
  @spec decode(String.t) :: String.t
  def decode(cipher) do
    cipher
    |> String.split
    |> Enum.map(&decoder/1)
    |> Enum.join
  end

  defp decoder(ciphertext) do
    for <<char::utf8 <- ciphertext>>, into: "", do: <<decode_char(char)>>
  end

  defp decode_char(char) when char in ?a..?z,
    do: ?a + mod((char - ?z) * (?z - ?a), ?z - ?a + 1)
  defp decode_char(char),
    do: char

  # Simple positive modulo
  defp mod(a, b) when a < b, do: mod(a + b, b)
  defp mod(a, b), do: rem(a, b)
end
