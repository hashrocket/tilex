defmodule TilexWeb.Api.DeveloperPostView do
  use TilexWeb, :view

  def render("index.json", %{posts: posts}) do
    %{
      data: %{
        posts: render_many(posts, TilexWeb.Api.PostView, "post.json")
      }
    }
  end
end
