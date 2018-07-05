defmodule Poker do
  @hand_ranking ~w{high_card pair two_pair trips straight flush full_house quads straight_flush}a
                |> Enum.with_index()
                |> Map.new()

  @face_cards %{"J" => 11, "Q" => 12, "K" => 13, "A" => 14}

  @doc """
  Given a list of poker hands, return a list containing the highest scoring hand.

  If two or more hands tie, return the list of tied hands in the order they were received.

  The basic rules and hand rankings for Poker can be found at:

  https://en.wikipedia.org/wiki/List_of_poker_hands

  For this exercise, we'll consider the game to be using no Jokers,
  so five-of-a-kind hands will not be tested. We will also consider
  the game to be using multiple decks, so it is possible for multiple
  players to have identical cards.

  Aces can be used in low (A 2 3 4 5) or high (10 J Q K A) straights, but do not count as
  a high card in the former case.

  For example, (A 2 3 4 5) will lose to (2 3 4 5 6).

  You can also assume all inputs will be valid, and do not need to perform error checking
  when parsing card values. All hands will be a list of 5 strings, containing a number
  (or letter) for the rank, followed by the suit.

  Ranks (lowest to highest): 2 3 4 5 6 7 8 9 10 J Q K A
  Suits (order doesn't matter): C D H S

  Example hand: ~w(4S 5H 4C 5D 4H) # Full house, 5s over 4s
  """
  @spec best_hand(list(list(String.t()))) :: list(list(String.t()))
  def best_hand(hands), do: Enum.reduce(hands, [], &rank_hand/2)

  defp rank_hand(hand, []) do
    [hand]
  end

  defp rank_hand(hand, [best | _rest] = best_hands) do
    {hand_rank, hand_kickers} = get_rank(hand)
    {best_rank, best_kickers} = get_rank(best)

    cond do
      @hand_ranking[hand_rank] > @hand_ranking[best_rank] -> [hand]
      @hand_ranking[hand_rank] < @hand_ranking[best_rank] -> best_hands
      true -> tiebreak({hand, hand_kickers}, {best_hands, best_kickers})
    end
  end

  defp get_rank(hand) do
    {ranks, suits} = hand |> Enum.map(&String.split_at(&1, -1)) |> Enum.unzip()
    suited? = Enum.all?(suits, fn s -> s == Enum.at(suits, 0) end)

    ranks = Enum.map(ranks, &numerical_rank/1)

    cond do
      suited? and straight?(Enum.sort(ranks)) ->
        {:straight_flush, [get_straight_high(ranks)]}

      suited? ->
        {:flush, Enum.sort(ranks, &(&1 >= &2))}

      straight?(Enum.sort(ranks)) ->
        {:straight, [get_straight_high(ranks)]}

      Enum.count(Enum.uniq(ranks)) == Enum.count(ranks) ->
        {:high_card, Enum.sort(ranks, &(&1 >= &2))}

      true ->
        get_groups(ranks)
    end
  end

  defp numerical_rank(rank) when rank in ["A", "J", "Q", "K"], do: @face_cards[rank]
  defp numerical_rank(rank), do: String.to_integer(rank)

  defp straight?([_c]), do: true
  defp straight?([a, b | rest]) when b == a + 1, do: straight?([b | rest])
  # Special case of {A 2 3 4 5} straight
  defp straight?([5, 14]), do: true
  defp straight?(_), do: false

  defp get_straight_high(ranks) do
    # Special case of {A 2 3 4 5} straight
    if 2 in ranks and 14 in ranks do
      5
    else
      Enum.max(ranks)
    end
  end

  defp get_groups(ranks) do
    groups = Enum.group_by(ranks, & &1)

    cond do
      Enum.any?(groups, fn {_k, v} -> length(v) == 4 end) ->
        {:quads, get_order(groups)}

      Enum.any?(groups, fn {_k, v} -> length(v) == 3 end) ->
        if map_size(groups) == 2 do
          {:full_house, get_order(groups)}
        else
          {:trips, get_order(groups)}
        end

      true ->
        if map_size(groups) == 3 do
          {:two_pair, get_order(groups)}
        else
          {:pair, get_order(groups)}
        end
    end
  end

  defp get_order(groups, n \\ 1, kickers \\ [])

  defp get_order(_groups, n, kickers) when n > 4 do
    kickers
  end

  defp get_order(groups, n, kickers) do
    n_kickers =
      groups
      |> Enum.filter(fn {_k, v} -> length(v) == n end)
      |> Enum.map(fn {k, _v} -> k end)
      |> Enum.sort(&(&1 >= &2))

    get_order(groups, n + 1, n_kickers ++ kickers)
  end

  defp tiebreak({hand, []}, {best_hands, []}), do: best_hands ++ [hand]

  defp tiebreak({hand, [k | rest]}, {best_hands, [k | other]}),
    do: tiebreak({hand, rest}, {best_hands, other})

  defp tiebreak({hand, [k | _rest]}, {_best_hands, [best_k | _other]}) when k > best_k, do: [hand]
  defp tiebreak({_hand, [_k | _rest]}, {best_hands, [_best_k | _other]}), do: best_hands
end
