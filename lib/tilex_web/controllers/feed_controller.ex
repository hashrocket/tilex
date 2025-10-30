defmodule TilexWeb.FeedController do
  use TilexWeb, :controller

  alias Tilex.Posts

  def index(conn, _params) do
    posts =
      from(
        p in Tilex.Blog.Post,
        order_by: [desc: p.inserted_at],
        preload: [:channel, :developer],
        limit: 25
      )
      |> Posts.published()
      |> Repo.all()

    conn
    |> put_resp_content_type("application/xml")
    |> render("index.xml", items: posts)
  end
end
