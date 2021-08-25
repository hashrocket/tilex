defmodule TilexWeb.Api.PostView do
  use TilexWeb, :view

  def render("index.json", %{posts: posts}) do
    %{
      data: %{
        posts: render_many(posts, TilexWeb.Api.PostView, "post.json")
      }
    }
  end

  def render("post.json", %{post: post}), do: Map.take(post, [:slug, :title])
end
