defmodule CollatzConjecture do
  defguardp is_even(value) when rem(value, 2) == 0

  @doc """
  calc/1 takes an integer and returns the number of steps required to get the
  number to 1 when following the rules:
    - if number is odd, multiply with 3 and add 1
    - if number is even, divide by 2
  """
  @spec calc(number :: pos_integer) :: pos_integer
  def calc(input) when is_integer(input) and input > 0, do: loop(input)

  defp loop(input, steps \\ 0)
  defp loop(1, steps), do: steps
  defp loop(input, steps) when is_even(input), do: loop(div(input, 2), steps + 1)
  defp loop(input, steps), do: loop(input * 3 + 1, steps + 1)
end
