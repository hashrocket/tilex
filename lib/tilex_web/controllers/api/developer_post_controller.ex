defmodule TilexWeb.Api.DeveloperPostController do

  @moduledoc """
    Provides an API endpoint for querying a developer's three latest posts.
  """

  use TilexWeb, :controller

  def index(conn, params) do
    posts = Tilex.Posts.by_developer(params["username"], limit: 3)

    render(conn, "index.json", posts: posts)
  end
end
