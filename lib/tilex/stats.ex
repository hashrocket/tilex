defmodule Tilex.Stats do
  import Ecto.Query
  import Tilex.QueryHelpers, only: [between: 3, greatest: 2, hours_since: 1]

  alias Ecto.Adapters.SQL
  alias Tilex.Repo
  alias Tilex.Channel

  def developer(%{start_date: start_date, end_date: end_date}) do
    start_time = Timex.to_datetime(start_date)
    end_time = end_date |> Timex.to_datetime() |> Timex.end_of_day()

    posts_where = fn query ->
      query
      |> where([p], between(p.inserted_at, ^start_time, ^end_time))
    end

    [
      start_date: format_date(start_date),
      end_date: format_date(end_date),
      channels: Repo.all(posts_by_channels_count() |> posts_where.()),
      developers: Repo.all(posts_by_developers_count() |> posts_where.()),
      developers_count: Repo.one(developers_count() |> posts_where.()),
      most_liked_posts: Repo.all(most_liked_posts() |> posts_where.()),
      hottest_posts: Repo.all(hottest_posts() |> posts_where.()),
      posts_count: Repo.one(posts_count() |> posts_where.()),
      channels_count: Repo.one(channels_count(start_time, end_time)),
      most_viewed_posts: Tilex.Tracking.most_viewed_posts(start_time, end_time),
      total_page_views: Tilex.Tracking.total_page_views(start_time, end_time)
    ]
  end

  def all do
    posts_for_days = query_posts_for_days!()

    [
      channels: Repo.all(posts_by_channels_count()),
      developers: Repo.all(posts_by_developers_count()),
      developers_count: Repo.one(developers_count()),
      most_liked_posts: Repo.all(most_liked_posts()),
      hottest_posts: Repo.all(hottest_posts()),
      posts_for_days: posts_for_days,
      posts_count: Repo.one(posts_count()),
      channels_count: Repo.one(channels_count()),
      max_count:
        ([1] ++ Enum.map(posts_for_days, fn [_, count] -> count end))
        |> Enum.max()
    ]
  end

  defp query_posts_for_days! do
    query_posts_for_days!("where inserted_at is not null", [])
  end

  defp query_posts_for_days!(%DateTime{} = start_time, %DateTime{} = end_time) do
    posts_where = "where inserted_at < $1::timestamp and inserted_at > $2::timestamp"
    query_posts_for_days!(posts_where, [start_time, end_time])
  end

  defp query_posts_for_days!(where, params) do
    posts_for_days_sql = """
      with posts as (
           select date((inserted_at at time zone 'America/New_York')::timestamptz) as post_date
              from posts
              #{where}
      )
      select dates_table.date, count(posts.post_date) from (
           select (
              generate_series(
                now()::date - '29 day'::interval, now()::date, '1 day'::interval
              )
           )::date as date
      ) as dates_table
      left outer join posts
      on posts.post_date = dates_table.date
      group by dates_table.date
      order by dates_table.date;
    """

    result = SQL.query!(Repo, posts_for_days_sql, params)
    result.rows
  end

  defp channels_count(start_time, end_time) do
    Channel
    |> join(:inner, [c], p in assoc(c, :posts))
    |> select([c, p], fragment("count(distinct(c0.id))"))
    |> where([c, p], between(p.inserted_at, ^start_time, ^end_time))
  end

  defp channels_count, do: from(c in "channels", select: fragment("count(*)"))

  defp developers_count, do: from(p in "posts", select: fragment("count(distinct(developer_id))"))
  defp posts_count, do: from(p in "posts", select: fragment("count(*)"))

  defp posts_and_channels do
    from(
      p in "posts",
      join: c in "channels",
      on: p.channel_id == c.id
    )
  end

  defp posts_and_developers do
    from(
      p in "posts",
      join: d in "developers",
      on: p.developer_id == d.id
    )
  end

  defp posts_by_channels_count do
    from(
      [p, c] in posts_and_channels(),
      group_by: c.name,
      order_by: [desc: count(p.id)],
      select: {count(p.id), c.name}
    )
  end

  defp posts_by_developers_count do
    from(
      [p, d] in posts_and_developers(),
      group_by: d.username,
      order_by: [desc: count(p.id)],
      select: {count(p.id), d.username}
    )
  end

  defp most_liked_posts do
    from(
      [p, c] in posts_and_channels(),
      order_by: [desc: p.likes],
      limit: 10,
      select: {p.title, p.likes, p.slug, c.name}
    )
  end

  defp hottest_posts do
    posts_with_age_in_hours =
      from(
        p in "posts",
        where: not is_nil(p.published_at),
        select: %{
          inserted_at: p.inserted_at,
          id: p.id,
          likes: p.likes,
          hours_age: greatest(hours_since(p.published_at), 0.1)
        }
      )

    from(
      p in subquery(posts_with_age_in_hours),
      join: posts in "posts",
      on: posts.id == p.id,
      join: channels in "channels",
      on: posts.channel_id == channels.id,
      order_by: [desc: 5],
      select: {
        posts.title,
        p.likes,
        posts.slug,
        channels.name,
        fragment("? / (? ^ ?)", p.likes, p.hours_age, 0.8)
      },
      limit: 10
    )
  end

  defp format_date(date) do
    # format with zero padding, Timex doesn't seem to have this feature
    "~4..0B-~2..0B-~2..0B"
    |> :io_lib.format([
      date.year,
      date.month,
      date.day
    ])
    |> IO.iodata_to_binary()
  end
end
