defmodule Phone do
  @invalid        "0000000000"
  @invalid_pretty "(000) 000-0000"
  @invalid_area   "000"

  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("212-555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 055-0100")
  "0000000000"

  iex> Phone.number("(212) 555-0100")
  "2125550100"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  @spec number(String.t) :: String.t
  def number(raw) do
    if valid_number?(raw), do: clean(raw), else: @invalid
  end

  @spec valid_number?(String.t) :: boolean
  defp valid_number?(str) do
    # Regex of DOOM
    re = ~r/^(\+1|1)? ?\(?[2-9][0-9]{2}\)?[ .-]?[2-9][0-9]{2}[ .-]?[0-9]{4}$/
    Regex.match?(re, str)
  end

  @spec clean(String.t) :: String.t
  defp clean(raw) do
    raw
    |> get_digits
    |> remove_country_code
  end

  @spec get_digits(String.t) :: String.t
  defp get_digits(raw), do: Regex.replace(~r/[^\d]/, raw, "")

  @spec remove_country_code(String.t) :: String.t
  defp remove_country_code(numbers) do
    if String.length(numbers) > 10 do
      String.slice(numbers, 1..-1)
    else
      numbers
    end
  end

  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("212-555-0100")
  "212"

  iex> Phone.area_code("+1 (212) 555-0100")
  "212"

  iex> Phone.area_code("+1 (012) 555-0100")
  "000"

  iex> Phone.area_code("867.5309")
  "000"
  """
  @spec area_code(String.t) :: String.t
  def area_code(raw) do
    if valid_number?(raw) do
      raw
      |> clean
      |> String.slice(0..2)
    else
      @invalid_area
    end
  end

  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("212-555-0100")
  "(212) 555-0100"

  iex> Phone.pretty("212-155-0100")
  "(000) 000-0000"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  @spec pretty(String.t) :: String.t
  def pretty(raw) do
    if valid_number?(raw) do
      <<area::binary-size(3), exchange::binary-size(3), local::binary-size(4)>> = clean(raw)
      "(" <> area <> ") " <> exchange <> "-" <> local
    else
      @invalid_pretty
    end
  end
end
