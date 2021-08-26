defmodule Tilex.Pageable do
  defmacro __using__(_params) do
    quote do
      import Tilex.Pageable
    end
  end

  def robust_page(%{"page" => page}) do
    case Integer.parse(page) do
      :error -> 1
      {integer, _remainder} -> integer
    end
  end

  def robust_page(_params), do: 1
end
