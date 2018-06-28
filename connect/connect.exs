defmodule Connect do
  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """

  @spec result_for([String.t()]) :: :none | :black | :white
  def result_for(board) do
    dimensions = {length(board) - 1, String.length(hd(board)) - 1}
  
    board
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {line, row}, clusters -> read_line(line, clusters, row) end)
    |> find_winner(dimensions)
  end

  defp read_line(line, clusters, row, col \\ 0)
  defp read_line("O" <> rest, clusters, row, col) do
    new_clusters = add_stone(Map.get(clusters, :white), {row, col})
    read_line(rest, Map.put(clusters, :white, new_clusters), row, col + 1)
  end
  defp read_line("X" <> rest, clusters, row, col) do
    new_clusters = add_stone(Map.get(clusters, :black), {row, col})
    read_line(rest, Map.put(clusters, :black, new_clusters), row, col + 1)
  end
  defp read_line(<<_cell::utf8, rest::binary>>, clusters, row, col) do
    read_line(rest, clusters, row, col + 1)
  end
  defp read_line("", clusters, _row, _col) do
    clusters
  end

  defp add_stone(clusters, stone) when is_nil(clusters) do
    MapSet.new([MapSet.new([stone])])
  end
  defp add_stone(clusters, stone) do
    {rest, connected} = Enum.split_with(clusters, &MapSet.disjoint?(&1, neighbors(stone)))
    new_cluster = Enum.reduce([MapSet.new([stone]) | connected], &MapSet.union/2)
    MapSet.new([new_cluster | rest])
  end

  defp neighbors({row, col}) do
    MapSet.new([{row-1, col}, {row-1, col+1}, {row, col-1}, 
            {row, col+1}, {row+1, col-1}, {row+1, col}])
  end

  defp find_winner(clusters, dimensions) do
    cond do
      Enum.any?(Map.get(clusters, :white, []), &connected_cluster?(&1, elem(dimensions, 0), 0)) -> :white
      Enum.any?(Map.get(clusters, :black, []), &connected_cluster?(&1, elem(dimensions, 1), 1)) -> :black
      true -> :none
    end
  end

  defp connected_cluster?(cluster, span, axis) do
    {first, last} = Enum.min_max_by(cluster, &elem(&1, axis))
    elem(last, axis) - elem(first, axis) == span
  end
end