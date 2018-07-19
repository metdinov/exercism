defmodule Bowling do
  @doc """
    Creates a new game of bowling that can be used to store the results of
    the game
  """
  @spec start() :: list
  def start, do: []

  @doc """
    Records the number of pins knocked down on a single roll. Returns `any`
    unless there is something wrong with the given number of pins, in which
    case it returns a helpful message.
  """
  @spec roll(list, integer) :: list | {:error, String.t()}
  def roll(_game, a) when a < 0, do: {:error, "Negative roll is invalid"}
  def roll(_game, a) when a > 10, do: {:error, "Pin count exceeds pins on the lane"}
  def roll(game, _a) when length(game) > 10, do: {:error, "Cannot roll after game is over"}
  def roll([frame | rest], a) when length(rest) == 9, do: bowl_last_frame(frame, a, rest)
  def roll(game, 10), do: [:strike | game]
  def roll([], a), do: [{a, :next_throw}]

  def roll([{first_throw, :next_throw} | _rest], a) when a > 10 - first_throw,
    do: {:error, "Pin count exceeds pins on the lane"}

  def roll([{first_throw, :next_throw} | rest], a), do: [{first_throw, a} | rest]
  def roll(game, a), do: [{a, :next_throw} | game]

  defp bowl_last_frame(:strike, a, rest), do: [{10, a, :next_throw} | rest]

  defp bowl_last_frame({10, a, :next_throw}, b, rest) when a == 10 or b <= 10 - a,
    do: [{10, a, b} | rest]

  defp bowl_last_frame({10, _a, :next_throw}, _b, _rest),
    do: {:error, "Pin count exceeds pins on the lane"}

  defp bowl_last_frame({first_throw, :next_throw}, a, rest) when a + first_throw == 10,
    do: [{first_throw, a, :next_throw} | rest]

  defp bowl_last_frame({first_throw, :next_throw}, a, _rest) when a > 10 - first_throw,
    do: {:error, "Pin count exceeds pins on the lane"}

  defp bowl_last_frame({first_throw, second_throw, :next_throw}, a, rest),
    do: [{first_throw, second_throw, a} | rest]

  defp bowl_last_frame({first_throw, :next_throw}, a, rest), do: [{first_throw, a} | rest]

  defp bowl_last_frame(_frame, _a, _rest), do: {:error, "Cannot roll after game is over"}

  @doc """
    Returns the score of a given game of bowling if the game is complete.
    If the game isn't complete, it returns a helpful message.
  """
  @spec score(any) :: integer | String.t()
  def score(game)
      when length(game) != 10
      when :strike == hd(game)
      when :next_throw == elem(hd(game), 2)
      when :next_throw == elem(hd(game), 3) do
    {:error, "Score cannot be taken until the end of the game"}
  end

  def score(game), do: Enum.reduce(game, {0, {0, 0}}, &scorer/2) |> elem(0)

  defp scorer({a, b, c}, _acc), do: {a + b + c, {a, b}}
  defp scorer(:strike, {total, {next, next2}}), do: {total + 10 + next + next2, {10, next}}

  defp scorer({a, b}, {total, {next, next2}}) when a + b == 10, do: {total + 10 + next, {a, b}}

  defp scorer({a, b}, {total, {_next, _next2}}), do: {total + a + b, {a, b}}
end
