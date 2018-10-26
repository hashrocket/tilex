defmodule Mix.Tasks.Tilex.PageViews do
  use Mix.Task
  import Mix.Ecto

  @shortdoc "Tilex Stats: Days in a row a til was posted"

  @moduledoc """
  Run `mix tilex.streaks` to get days in a row a til was posted.
  Run `mix tilex.streaks chriserin` to get days in a row a til was posted by chriserin.
  """

  def run(args) do
    repo =
      args
      |> parse_repo
      |> hd

    Application.ensure_all_started(:tilex)
    ensure_started(repo, [])

    string_pid = Tilex.PageViewsReport.report(repo)

    Tilex.Notifications.page_views_report(string_pid)
  end

  defp day_output([count, date, _period]) do
    "#{String.pad_leading(to_string(count), 10, " ")} #{format(date)}"
  end

  defp format(date) do
    Timex.format!(date, "%a %m/%d", :strftime)
  end
end
