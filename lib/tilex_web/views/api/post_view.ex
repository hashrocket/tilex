defmodule Tilex.Api.PostView do
  use TilexWeb, :view

  def render("post.json", %{post: post}), do: Map.take(post, [:slug, :title])
end
