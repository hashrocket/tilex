defmodule Features.VisitorViewsStatsTest do
  use Tilex.IntegrationCase, async: Application.get_env(:tilex, :async_feature_test)

  def text_without_newlines(element) do
    String.replace(Wallaby.Element.text(element), "\n", " ")
  end

  test "sees total number of posts by channel", %{session: session} do

    target_channel = Factory.insert!(:channel, name: "phoenix")
    other_channel = Factory.insert!(:channel, name: "other")

    Factory.insert!(:post, title: "functional programming rocks", channel: target_channel)

    Enum.each(["i'm fine", "all these people out here", "what?"], fn(title) ->
      Factory.insert!(:post, title: title, channel: other_channel)
    end)

    visit(session, "/statistics")
    channels = find(session, Query.css(".stats_column ul#channels"))

    query = Query.css(".stats_column header", text: "4 posts in 2 channels")
    channels_header = find(session, query)
    assert(channels_header)

    [other_channel, phoenix_channel] = all(channels, Query.css("li"))

    assert text_without_newlines(other_channel) =~ "#other 3 posts"
    assert text_without_newlines(phoenix_channel) =~ "#phoenix 1 post"
  end

  test "sees most liked and hottest tils", %{session: session} do
    posts = [
      "Controllers",
      "Views",
      "Templates",
    ]

    Factory.insert!(:channel, name: "phoenix")

    posts
    |> Enum.with_index
    |> Enum.each(fn({title, likes}) ->
      Factory.insert!(:post, title: title, likes: likes + 1)
    end)

    visit(session, "/statistics")

    most_liked_posts = find(session, Query.css("article.most_liked_posts"))
    most_liked_posts_header = find(most_liked_posts, Query.css("header"))

    assert Wallaby.Element.text(most_liked_posts_header) =~ "Most liked posts"

    [fast_tests, slow_tests, insert_mode] = all(most_liked_posts, Query.css("li"))

    assert text_without_newlines(fast_tests) =~ "Templates #phoenix • 3 likes"
    assert text_without_newlines(slow_tests) =~ "Views #phoenix • 2 likes"
    assert text_without_newlines(insert_mode) =~ "Controllers #phoenix • 1 like"

    hottest_posts = find(session, Query.css("article.hottest_posts"))
    hottest_posts_header = find(hottest_posts, Query.css("header"))

    assert Wallaby.Element.text(hottest_posts_header) =~ "Hottest posts"

    [fast_tests, slow_tests, insert_mode] = all(hottest_posts, Query.css("li"))

    assert text_without_newlines(fast_tests) =~ "Templates #phoenix • 3 likes"
    assert text_without_newlines(slow_tests) =~ "Views #phoenix • 2 likes"
    assert text_without_newlines(insert_mode) =~ "Controllers #phoenix • 1 like"
  end

  test "sees til activity", %{session: session} do
    dt = fn ({_y, _m, _d} = date) ->
      Ecto.DateTime.cast!({date, {12, 0, 0}})
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
    activity_tag = find(session, Query.css("ul#activity"))

    find(activity_tag,
         Query.css("li[data-amount='1'][data-date='Mon, #{Timex.format!(previous_monday, "%b %-e", :strftime)}']")
       )
    find(activity_tag,
         Query.css("li[data-amount='2'][data-date='Tue, #{Timex.format!(previous_tuesday, "%b %-e", :strftime)}']")
       )
    find(activity_tag,
         Query.css("li[data-amount='3'][data-date='Wed, #{Timex.format!(previous_wednesday, "%b %-e", :strftime)}']")
        )
  end

  test "sees total number of posts by developer", %{session: session} do

    developer = Factory.insert!(:developer, username: "makinpancakes")
    Factory.insert!(:post, developer: developer)

    visit(session, "/statistics")

    query = Query.css(".stats_column header", text: "1 author")
    developers_header = find(session, query)
    assert(developers_header)

    developers = find(session, Query.css(".stats_column ul#authors"))
    [developer] = all(developers, Query.css("li"))
    assert text_without_newlines(developer) =~ "makinpancakes 1 post"
  end
end
