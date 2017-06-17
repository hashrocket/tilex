defmodule Tilex.LayoutView do
  use Tilex.Web, :view

  def page_title(%{post: post}), do: " - #{post.title}"
  def page_title(%{channel: channel}), do: " - ##{channel.name}"
  def page_title(%{developer: developer}), do: " - #{developer.username}"
  def page_title(_), do: ""
end
