defmodule TilexWeb.Api.DeveloperPostView do
  use TilexWeb, :view

  def render("index.json", %{posts: posts}) do
    %{
      data: %{
        posts: render_many(posts, Tilex.Api.PostView, "post.json")
      }
    }
  end
end
