defmodule Connect do
  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """

  @spec result_for([String.t()]) :: :none | :black | :white
  def result_for(board) do
    white_stones = %{}
    black_stones = %{}
    span = length(board) - 1
    for {line, row} <- Enum.with_index(board) do
      for {cell, col} <- line |> String.graphemes |> Enum.with_index do
        case cell do
          "O" -> Map.update(white_stones, row, MapSet.new, &(MapSet.put(&1, col)))
          "X" -> Map.update(black_stones, col, MapSet.new, &(MapSet.put(&1, row)))
          _ -> nil
        end
      end
    end

    cond do
      winner?(white_stones, span) -> :white
      winner?(black_stones, span) -> :black
      true -> :none
    end
  end

  defp winner?(stones, rank) do
    winner?(stones, rank-1, Map.get(stones, rank, MapSet.new))
  end
  defp winner?(stones, rank, connected) do
    if MapSet.size(connected) == 0 do
      false
    else
      with {:ok, rank_stones} <- Map.fetch(stones, rank) do
        winner?(stones, rank-1, find_connected_stones(connected, rank_stones))
      else
        :error -> false
      end
    end
  end

  def find_connected_stones(connected, rank_stones) do
    find_group =  fn 
                    elem, [] -> 
                      {:cont, [elem]}
                    elem, [top | _rest] = group ->
                      if elem == top + 1 do
                        {:cont, [elem | group]}
                      else
                        {:cont, group, [elem]}
                      end
                  end
    after_func =  fn
                    [] -> {:cont, []}
                    group -> {:cont, group, []}
                  end

    rank_stones
    |> Enum.sort
    |> Enum.chunk_while([], find_group, after_func)
    |> Enum.filter(&Enum.any?(&1, fn s -> s in connected or s+1 in connected end))
    |> Enum.concat
    |> Enum.into(MapSet.new)
  end
end
