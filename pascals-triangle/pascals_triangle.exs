defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num) do
    1..num
    |> Enum.reduce([], &pascal(&1, &2))
    |> Enum.reverse
  end

  defp pascal(1, triangle) do
    [[1] | triangle]
  end
  defp pascal(n, [last | _rest] = triangle) do
    row =
      for i <- 0..(n - 1) do
        if i == 0 or i == n - 1 do
          1
        else
          Enum.at(last, i - 1) + Enum.at(last, i)
        end
      end
    [row | triangle]
  end
end
