defmodule Features.DeveloperViewsStatsTest do
  use Tilex.IntegrationCase, async: true

  def format_stats_date(%Date{year: year, day: day, month: month}) do
    day_s = String.pad_leading(Integer.to_string(day), 2, "0")
    month_s = String.pad_leading(Integer.to_string(month), 2, "0")

    "#{month_s}-#{day_s}-#{year}"
  end

  test "sees total number of posts by channel", %{session: session} do
    developer = Factory.insert!(:developer)
    phoenix_channel = Factory.insert!(:channel, name: "phoenix")
    other_channel = Factory.insert!(:channel, name: "other")

    Factory.insert!(
      :post,
      title: "functional programming rocks",
      channel: phoenix_channel
    )

    Enum.each(["i'm fine", "all these people out here", "what?"], fn title ->
      Factory.insert!(:post, title: title, channel: other_channel)
    end)

    Enum.each(["i'm not fine", "where are all the people", "okay."], fn title ->
      Factory.insert!(
        :post,
        inserted_at:
          DateTime.utc_now()
          |> DateTime.add(-:timer.hours(48), :millisecond)
          |> DateTime.truncate(:second),
        title: title,
        channel: other_channel
      )
    end)

    session
    |> sign_in(developer)
    |> visit("/developer/statistics")

    assert(
      session
      |> find(Query.css(".stats_column header", text: "7 posts in 2 channels"))
    )

    channels = find(session, Query.css(".stats_column ul#channels"))
    [other_channel, phoenix_channel] = all(channels, Query.css("li"))

    assert text_without_newlines(other_channel) =~ "#other 6 posts"
    assert text_without_newlines(phoenix_channel) =~ "#phoenix 1 post"

    session
    |> fill_in(Query.css("#start-date"),
      with: Date.utc_today() |> Date.add(-7) |> format_stats_date()
    )
    |> fill_in(Query.css("#end-date"),
      with: Date.utc_today() |> Date.add(-1) |> format_stats_date()
    )
    |> click(Query.css("#filter-submit"))

    assert(
      session
      |> find(Query.css(".stats_column header", text: "3 posts in 1 channel"))
    )

    channels = find(session, Query.css(".stats_column ul#channels"))
    [other_channel] = all(channels, Query.css("li"))

    assert text_without_newlines(other_channel) =~ "#other 3 posts"
  end

  test "does not see sees til activity chart", %{session: session} do
    developer = Factory.insert!(:developer)

    session
    |> sign_in(developer)
    |> visit("/developer/statistics")

    refute_has(session, Query.css("ul#activity"))
  end
end
