defmodule Tilex.Web.Api.DeveloperPostView do
  use Tilex.Web, :view

  def render("index.json", %{posts: posts}) do
    %{
      data: %{
        posts: render_many(posts, Tilex.Api.PostView, "post.json")
      }
    }
  end
end
