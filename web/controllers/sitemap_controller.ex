defmodule Tilex.SitemapController do
  use Tilex.Web, :controller

  def index(conn, _) do
    conn
    |> assign(:posts, Repo.all(Tilex.Post))
    |> put_layout(false)
    |> render("sitemap.xml")
  end
end
