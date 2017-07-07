defmodule Tilex.SitemapController do
  use Tilex.Web, :controller

  def index(conn, _) do
    conn = Plug.Conn.assign(conn, :posts, Repo.all(Tilex.Post))
    conn = put_layout conn, false
    conn = render conn, "sitemap.xml"
  end
end
