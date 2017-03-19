defmodule Tilex.Posts do
  import Ecto.Query

  alias Tilex.{Channel, Post, Repo}

  def all(page) do
    posts(page)
    |> Repo.all
  end

  def by_channel(channel_name, page) do
    channel = Repo.get_by!(Channel, name: channel_name)

    offset = (page - 1) * 50

    query = from p in Post,
      order_by: [desc: p.inserted_at],
      join: c in assoc(p, :channel),
      join: d in assoc(p, :developer),
      preload: [channel: c, developer: d],
      limit: 51,
      offset: ^offset,
      where: p.channel_id == ^channel.id

    {Repo.all(query), channel}
  end

  defp posts(page) do
    offset = (page - 1) * 50

    from p in Post,
      order_by: [desc: p.inserted_at],
      join: c in assoc(p, :channel),
      join: d in assoc(p, :developer),
      preload: [channel: c, developer: d],
      limit: 51,
      offset: ^offset
  end
end
