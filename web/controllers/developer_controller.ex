defmodule Tilex.DeveloperController do
  use Tilex.Web, :controller

  def show(conn, %{"name" => username} = params) do
    page = Map.get(params, "page", "1") |> String.to_integer

    {posts, developer} = Tilex.Posts.by_developer(username, page)

    render(conn, "show.html", developer: developer, posts: posts, page: page)
  end
end
