defmodule Connect do
  @doc """
  Calculates the winner (if any) of a board
  using "O" as the white player
  and "X" as the black player
  """

  @spec result_for([String.t()]) :: :none | :black | :white
  def result_for(board) do
    span = length(board) - 1
  
    board
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {line, row}, clusters -> read_line(line, clusters, row) end)
    |> find_winner(span)
  end

  def read_line(line, clusters, row, col \\ 0)
  def read_line("O" <> rest, clusters, row, col) do
    new_clusters = add_stone(Map.get(clusters, :white, MapSet.new), {row, col})
    read_line(rest, Map.put(clusters, :white, new_clusters), row, col + 1)
  end
  def read_line("X" <> rest, clusters, row, col) do
    new_clusters = add_stone(Map.get(clusters, :black, MapSet.new), {row, col})
    read_line(rest, Map.put(clusters, :black, new_clusters), row, col + 1)
  end
  def read_line(<<_cell::utf8, rest::binary>>, clusters, row, col) do
    read_line(rest, clusters, row, col + 1)
  end
  def read_line("", clusters, _row, _col) do
    clusters
  end

  def add_stone(clusters, stone) do
    cluster = 
      Enum.find(clusters, 
                MapSet.new,
                fn c -> not MapSet.disjoint?(c, neighbors(stone)) end)
    
    # WTB lens
    clusters
    |> MapSet.delete(cluster)
    |> MapSet.put(MapSet.put(cluster, stone))
  end

  def neighbors({row, col}) do
    MapSet.new([{row-1, col}, {row-1, col+1}, {row, col-1}, 
            {row, col+1}, {row+1, col-1}, {row+1, col}])
  end

  def find_winner(clusters, span) do
    cond do
      Enum.any?(Map.get(clusters, :white, []), &connected_cluster?(&1, span, 0)) -> :white
      Enum.any?(Map.get(clusters, :black, []), &connected_cluster?(&1, span, 1)) -> :black
      true -> :none
    end
  end

  def connected_cluster?(cluster, span, axis) do
    {first, last} = Enum.min_max_by(cluster, &elem(&1, axis))
    elem(last, axis) - elem(first, axis) == span
  end
end