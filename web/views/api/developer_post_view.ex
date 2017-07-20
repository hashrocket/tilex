defmodule Tilex.Api.DeveloperPostView do
  use Tilex.Web, :view

  def render("index.json", %{posts: posts}) do
    %{
      data: %{
        posts: Enum.map(posts, &post_json/1)
      }
    }
  end

  def post_json(post) do
    %{
      slug: post.slug,
      title: post.title,
    }
  end
end
