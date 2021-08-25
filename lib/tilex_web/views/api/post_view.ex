defmodule TilexWeb.Api.PostView do
  use TilexWeb, :view

  def render("index.json", %{posts: posts}) do
    %{
      data: %{
        posts: render_many(posts, TilexWeb.Api.PostView, "post_with_developer.json")
      }
    }
  end

  def render("post_with_developer.json", %{post: post}) do
    %{
      slug: post.slug,
      title: post.title,
      developer_username: post.developer.username,
      channel_name: post.channel.name
    }
  end

  def render("post.json", %{post: post}), do: Map.take(post, [:slug, :title])
end
