import Ecto.DateTime

defmodule Features.VisitorViewsStatsTest do
  use Tilex.IntegrationCase, async: true

  test "sees total number of posts by channel", %{session: session} do

    target_channel = Factory.insert!(:channel, name: "phoenix")
    other_channel = Factory.insert!(:channel, name: "other")

    Factory.insert!(:post, title: "functional programming rocks", channel: target_channel)

    Enum.each(["i'm fine", "all these people out here", "what?"], fn(title) ->
      Factory.insert!(:post, title: title, channel: other_channel)
    end)

    visit(session, "/statistics")
    channels = find(session, ".stats_column ul#channels")

    query = Wallaby.Query.css(".stats_column header", text: "5 posts in 2 channels")
    channels_header = find(session, query)
    assert(channels_header)

    [ other_channel, phoenix_channel ] = all(channels, "li")

    assert Wallaby.Browser.text(other_channel) =~ "#other\n3 posts"
    assert Wallaby.Browser.text(phoenix_channel) =~ "#phoenix\n1 post"
  end

  test "sees most liked tils", %{session: session} do
    posts = [
      "Controllers",
      "Views",
      "Templates",
    ]

    channel = Factory.insert!(:channel, name: "phoenix")

    posts
    |> Enum.with_index
    |> Enum.each(fn({title, likes}) ->
      Factory.insert!(:post, title: title, likes: likes + 1)
    end)

    visit(session, "/statistics")

    most_liked_posts = find(session, "article.most_liked_posts")
    channels_header = find(most_liked_posts, "header")

    assert Wallaby.Browser.text(channels_header) =~ "Most liked TILs"

    [ fast_tests, slow_tests, insert_mode ] = all(most_liked_posts, "li")

    assert Wallaby.Browser.text(fast_tests) =~ "Templates\n#phoenix • 3 likes"
    assert Wallaby.Browser.text(slow_tests) =~ "Views\n#phoenix • 2 likes"
    assert Wallaby.Browser.text(insert_mode) =~ "Controllers\n#phoenix • 1 like"
  end

  test "sees til activity", %{session: session} do
    dt = fn ({y, m, d} = date) ->
      Ecto.DateTime.from_date(Ecto.Date.cast!({2016, 3, 12}))
    end

    today = Timex.today
    day_of_the_week = :calendar.day_of_the_week(Date.to_erl(Timex.today))

    duration = Timex.Duration.from_days((day_of_the_week - 1) + 7)
    previous_monday = Timex.subtract(today, duration)

    previous_tuesday = Timex.add(previous_monday, Timex.Duration.from_days(1))
    previous_wednesday = Timex.add(previous_monday, Timex.Duration.from_days(2))

    Factory.insert!(:post, title: "Vim rules", inserted_at: dt.(Date.to_erl(previous_monday)))
    Factory.insert!(:post, title: "Vim rules", inserted_at: dt.(Date.to_erl(previous_tuesday)))
    Factory.insert!(:post, title: "Vim rules", inserted_at: dt.(Date.to_erl(previous_tuesday)))
    Factory.insert!(:post, title: "Vim rules", inserted_at: dt.(Date.to_erl(previous_wednesday)))
    Factory.insert!(:post, title: "Vim rules", inserted_at: dt.(Date.to_erl(previous_wednesday)))
    Factory.insert!(:post, title: "Vim rules", inserted_at: dt.(Date.to_erl(previous_wednesday)))

    visit(session, "/statistics")
    activity_tag = find(session, "ul#activity")

    thing = find(activity_tag,
                 css("li[data-amount='1'][data-date='Mon, #{Timex.format!(previous_monday, "%b %e", :strftime)}']")
               )
    thing = find(activity_tag,
                 css("li[data-amount='2'][data-date='Tue, #{Timex.format!(previous_tuesday, "%b %e", :strftime)}']")
               )
    thing = find(activity_tag,
                 css("li[data-amount='3'][data-date='Wed, #{Timex.format!(previous_wednesday, "%b %-e", :strftime)}']")
                )
  end
end