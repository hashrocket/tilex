defmodule Tilex.Posts do
  import Ecto.Query

  alias Tilex.{Channel, Developer, Post, Repo}

  def all(page) do
    posts(page)
    |> Repo.all
  end

  def by_channel(channel_name, page) do
    channel = Repo.get_by!(Channel, name: channel_name)

    offset = (page - 1) * Application.get_env(:tilex, :page_size)
    limit = Application.get_env(:tilex, :page_size) + 1

    query = from p in Post,
      order_by: [desc: p.inserted_at],
      join: c in assoc(p, :channel),
      join: d in assoc(p, :developer),
      preload: [channel: c, developer: d],
      limit: ^limit,
      offset: ^offset,
      where: p.channel_id == ^channel.id

    posts_count = Repo.one(from p in "posts",
      where: p.channel_id == ^channel.id,
      select: fragment("count(*)")
    )

    {Repo.all(query), posts_count, channel}
  end

  def by_developer(username, page) do
    developer = Repo.get_by!(Developer, username: username)

    offset = (page - 1) * Application.get_env(:tilex, :page_size)
    limit = Application.get_env(:tilex, :page_size) + 1

    query = from p in Post,
      order_by: [desc: p.inserted_at],
      join: c in assoc(p, :channel),
      join: d in assoc(p, :developer),
      preload: [channel: c, developer: d],
      limit: ^limit,
      offset: ^offset,
      where: p.developer_id == ^developer.id

    posts_count = Repo.one(from p in "posts",
      where: p.developer_id == ^developer.id,
      select: fragment("count(*)")
    )

    {Repo.all(query), posts_count, developer}
  end

  defp posts(page) do
    offset = (page - 1) * Application.get_env(:tilex, :page_size)
    limit = Application.get_env(:tilex, :page_size) + 1

    from p in Post,
      order_by: [desc: p.inserted_at],
      join: c in assoc(p, :channel),
      join: d in assoc(p, :developer),
      preload: [channel: c, developer: d],
      limit: ^limit,
      offset: ^offset
  end
end
