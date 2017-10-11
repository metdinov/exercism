defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
      :monday | :tuesday | :wednesday
    | :thursday | :friday | :saturday | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date
  def meetup(year, month, weekday, :first) do
    get_weekday(weekday, {year, month, 1})
  end
  def meetup(year, month, weekday, :second) do
    get_weekday(weekday, {year, month, 8})
  end
  def meetup(year, month, weekday, :third) do
    get_weekday(weekday, {year, month, 15})
  end
  def meetup(year, month, weekday, :fourth) do
    get_weekday(weekday, {year, month, 22})
  end
  def meetup(year, month, weekday, :last) do
    last_day = :calendar.last_day_of_the_month(year, month)
    get_weekday(weekday, {year, month, (last_day - 6)})
  end
  def meetup(year, month, weekday, :teenth) do
    get_weekday(weekday, {year, month, 13})
  end

  defp to_int(weekday) do
   case weekday do
     :monday -> 1
     :tuesday -> 2
     :wednesday -> 3
     :thursday -> 4
     :friday -> 5
     :saturday -> 6
     :sunday -> 7
   end
  end

  defp get_weekday(weekday, date) do
    int_day = to_int(weekday)
    find_date(int_day, date)
  end
  
  defp find_date(int_day, date = {year, month, day}) do
    if int_day == :calendar.day_of_the_week(date) do
      date
    else
      find_date(int_day, {year, month, day + 1})
    end
  end
end
