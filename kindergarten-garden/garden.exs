defmodule Garden do
  @children   [:alice, :bob, :charlie, :david, :eve, 
              :fred, :ginny, :harriet, :ileana, 
              :joseph, :kincaid, :larry]
  @seeds      %{?G => :grass, ?C => :clover, ?R => :radishes, ?V => :violets}

  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @spec info(String.t(), list) :: map
  def info(info_string, names \\ @children) do
    [row1, row2] = String.split(info_string)
    get_seeds(row1, row2, Enum.sort(names))
  end

  defp get_seeds(row1, row2, children, mapping \\ %{})
  defp get_seeds(<<seed1::utf8, seed2::utf8, row1::binary>>,
                <<seed3::utf8, seed4::utf8, row2::binary>>,
                [child | rest], mapping) do
    new_map = Map.put(mapping, child, 
              {@seeds[seed1], @seeds[seed2], @seeds[seed3], @seeds[seed4]})
    get_seeds(row1, row2, rest, new_map)
  end
  defp get_seeds("", "", [child | rest], mapping) do
    new_map = Map.put(mapping, child, {})
    get_seeds("", "", rest, new_map)
  end
  defp get_seeds(_row1, _row2, [], mapping) do
    mapping
  end
end
