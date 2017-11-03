defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t], pos_integer) :: map
  def frequency(texts, workers) do
    (1..workers)
    |> Enum.map(fn(_) -> spawn(__MODULE__, :worker, [self()]) end)
    |> scheduler(texts)
  end

  def worker(client) do
    send client, {:ready, self()}
    receive do
      {:freq, string} -> 
        send client, {:answer, calculate_frequency(string)}
        worker(client)

      {:shutdown} -> 
        exit(:normal)
    end
  end

  def scheduler(processes, texts, results \\ %{}) do
    receive do
      {:ready, pid} when length(texts) > 0 ->
        [text | rest] = texts
        send pid, {:freq, text}
        scheduler(processes, rest, results)
      {:ready, pid} ->
        send pid, {:shutdown}
        if length(processes) > 1 do
          scheduler(List.delete(processes, pid), texts, results)
        else
          results
        end
      {:answer, freq_map} ->
        scheduler(processes, texts, Map.merge(results, freq_map, fn(_key, v1, v2) -> v1 + v2 end))
    end
  end

  defp calculate_frequency(string) do
    string
    |> String.downcase
    |> String.graphemes
    |> Enum.filter(fn c -> c =~ ~r/\p{L}/u end)
    |> Enum.reduce(Map.new, fn(c, acc) -> Map.update(acc, c, 1, &(&1 + 1)) end)
  end
end
