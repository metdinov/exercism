defmodule BracketPush do
  @brackets %{?] => ?[, ?} => ?{, ?) => ?(}

  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t) :: boolean
  def check_brackets(str) do
    balanced?(str)
  end

  @spec balanced?(String.t, list) :: boolean
  defp balanced?(str, stack \\ [])
  defp balanced?("", stack) do
    Enum.empty?(stack)
  end
  defp balanced?(<<char::utf8, rest::binary>>, stack)
    when char in ~c/[{(/ do
    balanced?(rest, [char | stack])
  end
  defp balanced?(<<char::utf8, rest::binary>>, stack)
    when char in ~c/]})/ do
    open = @brackets[char]
    case stack do
      [^open | bottom] -> balanced?(rest, bottom)
      _ -> false
    end
  end
  defp balanced?(<<_::utf8, rest::binary>>, stack) do
    balanced?(rest, stack)
  end
end
