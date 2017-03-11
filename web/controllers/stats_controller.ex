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

      most_liked_posts = from([p, c] in posts_and_channels,
                              order_by: [desc: p.likes],
                              limit: 10,
                              select: {p.title, p.likes, p.slug, c.name})


    data = [
      channels: Repo.all(posts_by_channels_count),
      most_liked_posts: Repo.all(most_liked_posts)
    ]

    render(conn, "index.html", data)
  end
end
