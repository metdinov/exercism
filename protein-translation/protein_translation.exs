defmodule ProteinTranslation do
  @codon2protein  %{"UGU" => "Cysteine",
                    "UGC" => "Cysteine",
                    "UUA" => "Leucine",
                    "UUG" => "Leucine",
                    "AUG" => "Methionine",
                    "UUU" => "Phenylalanine",
                    "UUC" => "Phenylalanine",
                    "UCU" => "Serine",
                    "UCC" => "Serine",
                    "UCA" => "Serine",
                    "UCG" => "Serine",
                    "UGG" => "Tryptophan",
                    "UAU" => "Tyrosine",
                    "UAC" => "Tyrosine",
                    "UAA" => "STOP",
                    "UAG" => "STOP",
                    "UGA" => "STOP"}

  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: { atom,  list(String.t()) }
  def of_rna(rna) do
    codons = for <<a::utf8, b::utf8, c::utf8 <- rna>>, do: <<a::utf8, b::utf8, c::utf8>>
    recurse(codons, [])
  end

  defp recurse([codon | rest], protein_list) do
    case of_codon(codon) do
      {:ok, "STOP"} -> {:ok, Enum.reverse(protein_list)}
      {:ok, protein} -> recurse(rest, [protein | protein_list])
      {:error, _} -> {:error, "invalid RNA"}
    end
  end
  defp recurse([], protein_list), do: {:ok, Enum.reverse(protein_list)}

  @doc """
  Given a codon, return the corresponding protein

  UGU => Cysteine
  UGC -> Cysteine
  UUA -> Leucine
  UUG -> Leucine
  AUG -> Methionine
  UUU -> Phenylalanine
  UUC -> Phenylalanine
  UCU -> Serine
  UCC -> Serine
  UCA -> Serine
  UCG -> Serine
  UGG -> Tryptophan
  UAU -> Tyrosine
  UAC -> Tyrosine
  UAA -> STOP
  UAG -> STOP
  UGA -> STOP
  """
  @spec of_codon(String.t()) :: { atom, String.t() }
  def of_codon(codon) do
    case Map.fetch(@codon2protein, codon) do
      :error -> {:error, "invalid codon"}
      found -> found
    end
  end
end

