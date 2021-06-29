defmodule TilexWeb.HTMLHelpers do
  @moduledoc false

  use Phoenix.HTML

  def svg_tag(path), do: path |> File.read!() |> raw()
end
