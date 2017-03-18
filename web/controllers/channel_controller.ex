defmodule Tilex.ChannelController do
  use Tilex.Web, :controller

  def show(conn, %{"name" => channel_name} = params) do
    page = Map.get(params, "page", "1") |> String.to_integer

    {posts, channel} = Tilex.Posts.by_channel(channel_name, page)

    render(conn, "show.html", channel: channel, posts: posts, page: page)
  end
end
