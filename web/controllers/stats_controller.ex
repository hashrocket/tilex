defmodule Tilex.StatsController do
  use Tilex.Web, :controller

  def index(conn, params) do

    posts_and_channels = from(p in "posts",
                              join: c in "channels",
                              on: p.channel_id == c.id)

    posts_by_channels_count = from([p, c] in posts_and_channels,
                                   group_by: c.name,
                                   order_by: [desc: count(p.id)],
                                   select: {count(p.id), c.name}
                                  )

    data = [
      channels: Repo.all(posts_by_channels_count),
    ]

    render(conn, "index.html", data)
  end
end
