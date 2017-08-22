defmodule TilexWeb.ChannelController do
  use TilexWeb, :controller

  def show(conn, %{"name" => channel_name} = params) do
    page = params
    |> Map.get("page", "1")
    |> String.to_integer

    {posts, posts_count, channel} = Tilex.Posts.by_channel(channel_name, page)

    render(conn, "show.html",
      posts: posts,
      posts_count: posts_count,
      channel: channel,
      page: page
    )
  end
end
