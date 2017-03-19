defmodule Tilex.DeveloperController do
  use Tilex.Web, :controller

  def show(conn, %{"name" => username} = params) do
    page = Map.get(params, "page", "1") |> String.to_integer

    {posts, posts_count, developer} = Tilex.Posts.by_developer(username, page)

    render(conn, "show.html",
      posts: posts,
      posts_count: posts_count,
      developer: developer,
      page: page
    )
  end
end
