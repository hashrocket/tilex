defmodule TilexWeb.SitemapController do
  use TilexWeb, :controller

  alias Tilex.Posts

  def index(conn, _) do
    posts = Posts.published() |> Repo.all()

    conn
    |> assign(:posts, posts)
    |> assign(:channels, Repo.all(Tilex.Blog.Channel))
    |> put_layout(false)
    |> render("sitemap.xml")
  end
end
