defmodule TilexWeb.SitemapController do

  @moduledoc """
    Provides a function to display a sitemap.
  """

  use TilexWeb, :controller

  def index(conn, _) do
    conn
    |> assign(:posts, Repo.all(Tilex.Post))
    |> put_layout(false)
    |> render("sitemap.xml")
  end
end
