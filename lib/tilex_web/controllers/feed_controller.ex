defmodule TilexWeb.FeedController do
  use TilexWeb, :controller

  def index(conn, _params) do
    posts =
      Repo.all(
        from(
          p in Tilex.Blog.Post,
          where: not is_nil(p.published_at) and p.published_at <= fragment("now()"),
          order_by: [desc: p.inserted_at],
          preload: [:channel, :developer],
          limit: 25
        )
      )

    conn
    |> put_resp_content_type("application/xml")
    |> render("index.xml", items: posts)
  end
end
