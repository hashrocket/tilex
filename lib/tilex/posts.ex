defmodule Tilex.Posts do
  import Ecto.Query

  alias Ecto.Adapters.SQL
  alias Tilex.{Channel, Developer, Post, Repo}

  def all(page) do
    page
    |> posts
    |> Repo.all
  end

  def by_channel(channel_name, page) do
    channel = Repo.get_by!(Channel, name: channel_name)

    query = page
    |> posts
    |> where([p], p.channel_id == ^channel.id)

    posts_count = Repo.one(from p in Post,
      where: p.channel_id == ^channel.id,
      select: fragment("count(*)")
    )

    {Repo.all(query), posts_count, channel}
  end

  def by_developer(username, limit: limit) do
    query = from p in Post,
      order_by: [desc: p.inserted_at],
      join: d in assoc(p, :developer),
      limit: ^limit,
      where: d.username == ^username

    Repo.all(query)
  end

  def by_developer(username, page) do
    developer = Repo.get_by!(Developer, username: username)

    query = page
    |> posts
    |> where([p], p.developer_id == ^developer.id)

    posts_count = Repo.one(from p in Post,
      where: p.developer_id == ^developer.id,
      select: fragment("count(*)")
    )

    {Repo.all(query), posts_count, developer}
  end

  def by_search(search_query, page) do
    sql = """
      select p.* from posts p
        join developers d on d.id = p.developer_id
        join channels c on c.id = p.channel_id
        join lateral (
          select ts_rank_cd(
            setweight(to_tsvector('english', p.title), 'A')
            ||
            setweight(to_tsvector('english', d.username), 'B')
            ||
            setweight(to_tsvector('english', c.name), 'B')
            ||
            setweight(to_tsvector('english', p.body), 'C')
            ,
            plainto_tsquery('english', $1)
          ) as rank
        ) ranks on true
        where ranks.rank > 0
        order by ranks.rank desc, p.inserted_at desc
    """

    results = SQL.query!(Repo, sql, [search_query])

    posts = results.rows
    |> Enum.map(&Repo.load(Post, {results.columns, &1}))
    |> Repo.preload(:developer)
    |> Repo.preload(:channel)

    offset = (page - 1) * Application.get_env(:tilex, :page_size)
    limit = Application.get_env(:tilex, :page_size) + 1

    {Enum.slice(posts, offset..(offset + limit)), Enum.count(posts)}
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
