defmodule Bob do
  import String, only: [upcase: 1, downcase: 1, trim: 1, ends_with?: 2]

  def hey(), do: "Fine. Be that way!"
  def hey(input) do
    cond do
      trim(input) == "" -> hey()
      ends_with?(input, "?") -> "Sure."
      input == upcase(input) && input != downcase(input) -> "Whoa, chill out!"
      true -> "Whatever."
    end
  end
end
