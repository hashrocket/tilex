defmodule TilexWeb.SitemapController do
  use TilexWeb, :controller

  def index(conn, _) do
    conn
    |> assign(:posts, Repo.all(Tilex.Blog.Post))
    |> assign(:channels, Repo.all(Tilex.Blog.Channel))
    |> put_layout(false)
    |> render("sitemap.xml")
  end
end
