defmodule SecretHandshake do
  use Bitwise, only_operators: true
  @codes ["wink", "double blink", "close your eyes", "jump"]

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    result = for {codeword, i} <- Enum.with_index(@codes), (code &&& (1 <<< i)) != 0, do: codeword
    if (code &&& (1 <<< 4)) != 0 do
      Enum.reverse(result)
    else
      result
    end
  end
end

