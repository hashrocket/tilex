defmodule TilexWeb.Api.DeveloperPostController do
  use TilexWeb, :controller

  def index(conn, params) do
    posts = Tilex.Posts.by_developer(params["username"], limit: 3)

    render(conn, "index.json", posts: posts)
  end
end
