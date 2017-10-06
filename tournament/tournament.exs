defmodule Tournament do
  @header "Team                           | MP |  W |  D |  L |  P\n"

  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    input
    |> read_results
    |> sort_results
    |> add_header
  end

  defp read_results(lines, results \\ %{})
  defp read_results([], results),
    do: results
  defp read_results([line | rest], results),
    do: read_results(rest, update_results(line, results))

  defp update_results(line, results) do
    with [team_a, team_b, outcome] when outcome in ["win", "draw", "loss"] <- String.split(line, ";")
    do
      {_, results} = 
        Map.get_and_update(results, team_a, fn(t) -> {t, update_team_tally(t, outcome)} end)
      opponent_outcome = flip_outcome(outcome)
      {_, results} =
        Map.get_and_update(results, team_b, fn(t) -> {t, update_team_tally(t, opponent_outcome)} end)
        results
    else
      _ -> results
    end
  end

  defp update_team_tally(nil, outcome), do: update_team_tally({0, 0, 0, 0, 0}, outcome)
  defp update_team_tally({mp, w, d, l, p}, "win"), do: {mp + 1, w + 1, d, l, p + 3}
  defp update_team_tally({mp, w, d, l, p}, "draw"), do: {mp + 1, w, d + 1, l, p + 1}
  defp update_team_tally({mp, w, d, l, p}, "loss"), do: {mp + 1, w, d, l + 1, p}

  defp flip_outcome("win"), do: "loss"
  defp flip_outcome("loss"), do: "win"
  defp flip_outcome("draw"), do: "draw"

  defp sort_results(results) do
    results
    |> Enum.sort(&sorter/2)
    |> Enum.map_join("\n", &format/1)
  end

  defp sorter({team_a, {_, _, _, _, points}},
              {team_b, {_, _, _, _, points}}) do
    team_a <= team_b
  end
  defp sorter({_, {_, _, _, _, points_a}}, 
              {_, {_, _, _, _, points_b}}) do
    points_a > points_b
  end

  defp format({team, {mp, w, d, l, p}}) do
    mp = mp |> to_string |> String.pad_leading(2)
    String.pad_trailing(team, 31) <> "| #{mp} |  #{w} |  #{d} |  #{l} |  #{p}"
  end

  defp add_header(table), do: @header <> table
end