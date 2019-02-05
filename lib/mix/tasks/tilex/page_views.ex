defmodule Mix.Tasks.Tilex.PageViews do
  use Mix.Task

  @shortdoc "Tilex Page Views: Highlight page views stats for the last couple of weeks"

  @moduledoc """
  Run `mix tilex.page_views` to print a report that looks like this:

  Best Day Last Week:         3526 Wed 10/17
  Last Week:                 19571 Mon 10/15
  Best Day Week Before:       3416 Tue 10/09
  Week Before:               18420 Mon 10/08

  Run `mix tilex.page_views notify` to also send that report to any notifiers
  """

  def run([]) do
    run(["no-notifications"])
  end

  def run([notification]) do
    Application.ensure_all_started(:tilex)

    {status, report} = Tilex.PageViewsReport.report()

    if status == :ok do
      IO.puts(report)

      if notification == "notify" do
        Tilex.Notifications.page_views_report(report)
      end
    else
      IO.puts("no data available")
    end
  end
end
