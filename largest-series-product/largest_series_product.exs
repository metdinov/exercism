defmodule Series do

  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t, non_neg_integer) :: non_neg_integer
  def largest_product(number_string, size) when size < 0 or size > byte_size(number_string) do
    raise ArgumentError    
  end
  def largest_product("", size) when size > 0 do
    raise ArgumentError
  end
  def largest_product(number_string, size) do
    for start <- 0..(String.length(number_string) - size),
        number = String.slice(number_string, start, size) do
        calculate_product(number)
    end
    |> Enum.max
  end

  def calculate_product(number, acc \\ 1)
  def calculate_product("", acc),
    do: acc
  def calculate_product(<<num::utf8, rest::binary>>, acc) when num in ?0..?9,
    do: calculate_product(rest, acc * String.to_integer(<<num>>))
end
