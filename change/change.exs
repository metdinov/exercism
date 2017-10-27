defmodule Change do

  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t}
  def generate(_coins, target) when target < 0 do
    {:error, "cannot change"}
  end
  def generate(coins, target) do
    coins
    |> Enum.sort(fn(x, y) -> x >= y end)
    |> find_change(target)
  end

  defp find_change(coins, target, change \\ [], min_coins \\ :infinity)
  defp find_change(_coins, 0, change, _min_coins) do
    {:ok, change}
  end
  defp find_change(_coins, _target, change, min_coins) when length(change) + 1 >= min_coins do
    {:error, "Non optimal"}
  end
  defp find_change([coin | rest] = coins, target, change, min_coins) when target >= coin do
    with {:ok, change_right} <- find_change(coins, target - coin, [coin |change], min_coins) do
      with {:ok, change_left} <- find_change(rest, target, change, length(change_right)) do
        if length(change_right) <= length(change_left) do
          {:ok, change_right}
        else
          {:ok, change_left}
        end
      else
        _error -> {:ok, change_right}
      end
    else
      _error -> find_change(rest, target, change, min_coins)
    end
  end
  defp find_change([_coin | rest], target, change, min_coins) do
    find_change(rest, target, change, min_coins)
  end
  defp find_change([], _target, _change, _min_coins) do
    {:error, "cannot change"}
  end
end
