defmodule Tilex.Posts do
  import Ecto.Query

  alias Tilex.{Channel, Developer, Post, Repo}

  def all(page) do
    posts(page)
    |> Repo.all
  end

  def by_channel(channel_name, page) do
    channel = Repo.get_by!(Channel, name: channel_name)

    query = posts(page)
            |> where([p], p.channel_id == ^channel.id)

    posts_count = Repo.one(from p in "posts",
      where: p.channel_id == ^channel.id,
      select: fragment("count(*)")
    )

    {Repo.all(query), posts_count, channel}
  end

  def by_developer(username, page) do
    developer = Repo.get_by!(Developer, username: username)

    query = posts(page)
            |> where([p], p.developer_id == ^developer.id)

    posts_count = Repo.one(from p in "posts",
      where: p.developer_id == ^developer.id,
      select: fragment("count(*)")
    )

    {Repo.all(query), posts_count, developer}
  end

  def by_search(search_query, page) do
    query = posts(page)
            |> where([p], ilike(p.title, ^"%#{search_query}%"))

    posts_count = Repo.one(from p in "posts",
      where: ilike(p.title, ^"%#{search_query}%"),
      select: fragment("count(*)")
    )

    {Repo.all(query), posts_count}
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
