defmodule Tilex.Stats do
  import Ecto.Query

  alias Ecto.Adapters.SQL
  alias Tilex.Repo

  defmacro greatest(value1, value2) do
    quote do
      fragment("greatest(?, ?)", unquote(value1), unquote(value2))
    end
  end

  defmacro hours_since(timestamp) do
    quote do
      fragment(
        "extract(epoch from (current_timestamp - ?)) / 3600",
        unquote(timestamp)
      )
    end
  end

  def all do
    posts_for_days_sql = """
      with posts as (
           select date((inserted_at at time zone 'America/New_York')::timestamptz) as post_date
              from posts
              where inserted_at is not null
      )
      select dates_table.date, count(posts.post_date) from (
           select (generate_series(now()::date - '29 day'::interval, now()::date, '1 day'::interval))::date as date
      ) as dates_table
      left outer join posts
      on posts.post_date=dates_table.date
      group by dates_table.date
      order by dates_table.date;
    """

    result = SQL.query!(Repo, posts_for_days_sql, [])
    posts_for_days = result.rows

    posts_and_channels = from(p in "posts",
                              join: c in "channels",
                              on: p.channel_id == c.id)

    posts_and_developers = from(p in "posts",
                              join: d in "developers",
                              on: p.developer_id == d.id)

    posts_by_channels_count = from([p, c] in posts_and_channels,
                                   group_by: c.name,
                                   order_by: [desc: count(p.id)],
                                   select: {count(p.id), c.name}
                                  )

    posts_by_developers_count = from([p, d] in posts_and_developers,
                                   group_by: d.username,
                                   order_by: [desc: count(p.id)],
                                   select: {count(p.id), d.username}
                                  )

    most_liked_posts = from([p, c] in posts_and_channels,
                            order_by: [desc: p.likes],
                            limit: 10,
                            select: {p.title, p.likes, p.slug, c.name})

    hottest_posts = hot_posts()

    posts_count = Repo.one(from p in "posts", select: fragment("count(*)"))
    channels_count = Repo.one(from c in "channels", select: fragment("count(*)"))
    developers_count = Repo.one(from p in "posts", select: fragment("count(distinct(developer_id))"))

    data = [
      channels: Repo.all(posts_by_channels_count),
      developers: Repo.all(posts_by_developers_count),
      developers_count: developers_count,
      most_liked_posts: Repo.all(most_liked_posts),
      hottest_posts: Repo.all(hottest_posts),
      posts_for_days: posts_for_days,
      posts_count: posts_count,
      channels_count: channels_count,
      max_count: [1] ++ Enum.map(posts_for_days, fn([_, count]) -> count end)
      |> Enum.max
    ]

    data
  end

  defp hot_posts do
    posts_with_age_in_hours =
       from(p in "posts",
       where: not is_nil(p.published_at),
       select: %{
         id: p.id,
         likes: p.likes,
         hours_age: greatest(hours_since(p.published_at), 0.1)
       })

     from(p in subquery(posts_with_age_in_hours),
       join: posts in "posts", on: posts.id == p.id,
       join: channels in "channels", on: posts.channel_id == channels.id,
       order_by: [desc: 5],
       select: {
         posts.title,
         p.likes,
         posts.slug,
         channels.name,
         fragment("? / (? ^ ?)",
                   p.likes,
                   p.hours_age,
                   0.8)
       },
       limit: 10)
  end

end
