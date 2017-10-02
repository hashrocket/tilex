defmodule Mix.Tasks.Tilex.Streaks do
  use Mix.Task
  import Mix.Ecto

  @shortdoc "Tilex Stats: Days in a row a til was posted"

  @moduledoc """
  Run `mix tilex.streaks` to get days in a row a til was posted.
  Run `mix tilex.streaks chriserin` to get days in a row a til was posted by chriserin.
  """

  def run([]), do: run(["%"])
  def run([username] = args) do
    repo = args
           |> parse_repo
           |> hd

    streaks_sql = """
      with days as (
        select generate_series('4-12-2015'::date, now()::date, '1 day'::interval)::date as series_date
      ), specific_posts as (
        select
          p.inserted_at,
          developers.username
        from posts p
        inner join developers on p.developer_id = developers.id
        where username like $1
      ), all_til_days as (
        select
          inserted_at::date post_inserted,
          d.series_date series_date,
          username
        from specific_posts p
        right join days d on d.series_date = p.inserted_at::date
      ), partitioned_days as (
        select
          post_inserted,
          username,
          (select max(sub.series_date) from all_til_days sub where sub.post_inserted is null and sub.series_date < orig.series_date) last_unposted_day
        from all_til_days orig where post_inserted is not null
      ), streaks as (
        select
          count(distinct post_inserted) streak_length,
          min(post_inserted) start_date,
          max(post_inserted) end_date,
          array_agg(distinct username)
        from partitioned_days
        group by last_unposted_day
        having count(distinct post_inserted) >= 5
        order by streak_length desc
      )
      select * from streaks;
    """

    ensure_started(repo, [])

    {:ok, result} = repo.query(streaks_sql, [username], log: false)

    Enum.each(result.rows, fn ([streak_length, start_date, end_date, _people]) ->
      formatted_start_date = Timex.format!(start_date, "%m/%d/%Y", :strftime)
      formatted_end_date = Timex.format!(end_date, "%m/%d/%Y", :strftime)

      IO.puts "#{streak_length} days from #{formatted_start_date} to #{formatted_end_date}"
    end)
  end
end
