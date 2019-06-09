defmodule Features.DeveloperViewsStatsTest do
  use Tilex.IntegrationCase, async: Application.get_env(:tilex, :async_feature_test)

  setup_all do
    developer = Factory.insert!(:developer)
    {:ok, developer: developer}
  end

  test "sees total number of posts by channel", %{session: session, developer: developer} do
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
        inserted_at: Timex.to_datetime({2010, 1, 1}),
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
    |> fill_in(Query.css("#start-date"), with: "01-01-2009")
    |> fill_in(Query.css("#end-date"), with: "01-01-2011")
    |> click(Query.css("#filter-submit"))

    assert(
      session
      |> find(Query.css(".stats_column header", text: "3 posts in 1 channel"))
    )

    channels = find(session, Query.css(".stats_column ul#channels"))
    [other_channel] = all(channels, Query.css("li"))

    assert text_without_newlines(other_channel) =~ "#other 3 posts"
  end

  test "does not see sees til activity chart", %{session: session, developer: developer} do
    session
    |> sign_in(developer)
    |> visit("/developer/statistics")

    refute_has(session, Query.css("ul#activity"))
  end
end
