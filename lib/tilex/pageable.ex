defmodule Tilex.Pageable do
  def robust_page(%{"page" => page}) do
    case Integer.parse(page) do
      {integer, ""} -> integer
      _ -> 1
    end
  end

  def robust_page(_params), do: 1
end
