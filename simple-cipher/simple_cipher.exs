defmodule SimpleCipher do
  @doc """
  Given a `plaintext` and `key`, encode each character of the `plaintext` by
  shifting it by the corresponding letter in the alphabet shifted by the number
  of letters represented by the `key` character, repeating the `key` if it is
  shorter than the `plaintext`.

  For example, for the letter 'd', the alphabet is rotated to become:

  defghijklmnopqrstuvwxyzabc

  You would encode the `plaintext` by taking the current letter and mapping it
  to the letter in the same position in this rotated alphabet.

  abcdefghijklmnopqrstuvwxyz
  defghijklmnopqrstuvwxyzabc

  "a" becomes "d", "t" becomes "w", etc...

  Each letter in the `plaintext` will be encoded with the alphabet of the `key`
  character in the same position. If the `key` is shorter than the `plaintext`,
  repeat the `key`.

  Example:

  plaintext = "testing"
  key = "abc"

  The key should repeat to become the same length as the text, becoming
  "abcabca". If the key is longer than the text, only use as many letters of it
  as are necessary.
  """
  def encode(plaintext, key), do: encoder(plaintext, key)

  defp encoder(plaintext, key, ciphertext \\ "")
  defp encoder("", _key, ciphertext),
    do: ciphertext
  defp encoder(<<char::utf8, rest::binary>>, key, ciphertext) when char not in ?a..?z,
    do: encoder(rest, key, ciphertext <> <<char>>)
  defp encoder(<<char::utf8, rest::binary>>, <<k::utf8, ey::binary>>, ciphertext),
    do: encoder(rest, ey <> <<k>>, ciphertext <> <<?a + rem(char + k - 2 * ?a, ?z - ?a + 1)>>)

  @doc """
  Given a `ciphertext` and `key`, decode each character of the `ciphertext` by
  finding the corresponding letter in the alphabet shifted by the number of
  letters represented by the `key` character, repeating the `key` if it is
  shorter than the `ciphertext`.

  The same rules for key length and shifted alphabets apply as in `encode/2`,
  but you will go the opposite way, so "d" becomes "a", "w" becomes "t",
  etc..., depending on how much you shift the alphabet.
  """
  def decode(ciphertext, key) do
    decrypt_key = for <<k::utf8 <- key>>, into: "", do: <<?a + rem(?z - k + 1, ?z - ?a +1)>>
    encoder(ciphertext, decrypt_key)
  end
end

