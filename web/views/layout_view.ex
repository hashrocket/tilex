defmodule Tilex.LayoutView do
  use Tilex.Web, :view

  def page_title(assigns) do
    cond do
      Map.get(assigns, :post) ->
        " - #{assigns.post.title}"
      Map.get(assigns, :channel) ->
        " - ##{assigns.channel.name}"
      Map.get(assigns, :developer) ->
        " - #{assigns.developer.username}"
      true -> ""
    end
  end
end
