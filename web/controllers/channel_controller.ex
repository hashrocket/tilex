defmodule Tilex.ChannelController do
  use Tilex.Web, :controller

  alias Tilex.{Post, Channel}

  def show(conn, %{"name" => name}) do
    channel = Repo.get_by!(Channel, name: name)
    posts = Repo.all from p in Post,
      where: p.channel_id == ^channel.id,
      order_by: [desc: p.inserted_at],
      join: c in assoc(p, :channel),
      preload: [channel: c]
    render(conn, "show.html", channel: channel, posts: posts)
  end
end
