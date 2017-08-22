defmodule Tilex.Cache do
  def cache(key, value_block) do
    :tilex_cache
    |> Cachex.get(key)
    |> process_cache(key, value_block)
  end

  defp process_cache({:ok, value}, _, _), do: value

  defp process_cache({:missing, _}, key, value_block) do
    value = value_block.()
    Cachex.set!(:tilex_cache, key, value)
    value
  end
end
