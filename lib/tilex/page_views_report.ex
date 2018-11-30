defmodule Tilex.PageViewsReport do
  def report(repo \\ Tilex.Repo) do
    sql = """
    ((select count(*), date_trunc('day', request_time at time zone 'america/chicago'), 'day' as period from requests  where request_time between date_trunc('week', now() at time zone 'america/chicago') - '2 weeks'::interval and date_trunc('week', now() at time zone 'america/chicago') group by date_trunc('day', request_time at time zone 'america/chicago') order by date_trunc desc)
    union
    (select count(*), date_trunc('week', request_time at time zone 'america/chicago'), 'week' as period from requests  where request_time between date_trunc('week', now() at time zone 'america/chicago') - '2 weeks'::interval and date_trunc('week', now() at time zone 'america/chicago') group by date_trunc('week', request_time at time zone 'america/chicago') order by date_trunc desc)) order by date_trunc desc;
    """

    {:ok, result} = repo.query(sql, [], log: false)

    create_report(result.rows)
  end

  defp create_report([]), do: {:norows, ""}

  defp create_report(rows) do
    last_week_row =
      rows
      |> Enum.find(fn [_, _, period] -> period == "week" end)

    best_day_last_week =
      rows
      |> Enum.filter(fn [_, _, p] -> p == "day" end)
      |> Enum.filter(fn [_, d, _] ->
        Timex.compare(d, Enum.at(last_week_row, 1)) == 1 or
          Timex.compare(d, Enum.at(last_week_row, 1)) == 0
      end)
      |> Enum.sort_by(fn [c | _] -> c end)
      |> Enum.reverse()
      |> hd

    previous_week_row =
      rows
      |> Enum.filter(fn [_, _, period] -> period == "week" end)
      |> Enum.reverse()
      |> hd

    best_day_previous_week =
      rows
      |> Enum.filter(fn [_, _, p] -> p == "day" end)
      |> Enum.filter(fn [_, d, _] ->
        (Timex.compare(d, Enum.at(previous_week_row, 1)) == 1 or
           Timex.compare(d, Enum.at(previous_week_row, 1)) == 0) and
          Timex.compare(d, Enum.at(last_week_row, 1)) == -1
      end)
      |> Enum.sort_by(fn [c | _] -> c end)
      |> Enum.reverse()
      |> hd

    report = """
    Best Day Last Week:   #{day_output(best_day_last_week)}
    Last Week:            #{day_output(last_week_row)}
    Best Day Week Before: #{day_output(best_day_previous_week)}
    Week Before:          #{day_output(previous_week_row)}
    """

    {:ok, report}
  end

  defp day_output([count, date, _period]) do
    "#{String.pad_leading(to_string(count), 10, " ")} #{format(date)}"
  end

  defp format(date) do
    Timex.format!(date, "%a %m/%d", :strftime)
  end
end
