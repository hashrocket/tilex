defmodule Tilex.Cache do
  def cache(key, value_block) do
    :tilex_cache
    |> Cachex.get(key)
    |> process_cache(key, value_block)
  end

  defp process_cache({:ok, nil}, key, value_block) do
    value = value_block.()
    Cachex.put!(:tilex_cache, key, value)
    value
  end

  defp process_cache({:ok, value}, _, _), do: value
end
