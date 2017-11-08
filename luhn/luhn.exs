defmodule Luhn do

  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    with  trimmed <- String.replace(number, " ", ""),
          {num, ""} <- Integer.parse(trimmed) do
      String.length(trimmed) > 1 and rem(luhn_sum(num), 10) == 0
    else
      _error -> false
    end
  end

  defp luhn_sum(number, even_digit? \\ false, checksum \\ 0)
  defp luhn_sum(0, _even_digit?, checksum) do
    checksum
  end
  defp luhn_sum(number, even_digit?, checksum) when even_digit? do
    result = 2 * rem(number, 10)
    result = if result > 9, do: result - 9, else: result
    luhn_sum(div(number, 10), not even_digit?, checksum + result)
  end  
  defp luhn_sum(number, even_digit?, checksum) do
    luhn_sum(div(number, 10), not even_digit?, checksum + rem(number, 10))
  end

end