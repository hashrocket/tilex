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
      {"Insert mode", "vim"},
      {"Slow Tests", "Rails"},
      {"Fast Tests", "Elixir"}
    ]

    posts
    |> Enum.with_index
    |> Enum.each(fn({{title, channel}, likes}) ->
      Factory.insert!(:post, title: title, likes: likes + 1)
    end)

    visit(session, "/statistics")

    most_liked_posts = find(session, "article.most_liked_posts")
    channels_header = find(most_liked_posts, "header")

    assert Wallaby.Browser.text(channels_header) =~ "Most liked TILs"

    [ fast_tests, slow_tests, insert_mode ] = all(most_liked_posts, "li")

    assert Wallaby.Browser.text(fast_tests) =~ "Fast Tests\n#Elixir • 3 likes"
    assert Wallaby.Browser.text(slow_tests) =~ "Slow Tests\n#Rails • 2 likes"
    assert Wallaby.Browser.text(insert_mode) =~ "Insert mode\n#vim • 1 like"
  end

  test "sees til activity", %{session: session} do
    # create tils for specific days in the last 30 days
    #

    dt = fn ({y, m, d} = date) ->
      Ecto.DateTime.from_date(Ecto.Date.cast!({2016, 3, 12}))
    end

    Factory.insert!(:post, title: "Vim rules", inserted_at: dt.({2016, 3, 12}))
    Factory.insert!(:post, title: "Vim rules", inserted_at: dt.({2016, 3, 13}))
    Factory.insert!(:post, title: "Vim rules", inserted_at: dt.({2016, 3, 13}))
    Factory.insert!(:post, title: "Vim rules", inserted_at: dt.({2016, 3, 14}))
    Factory.insert!(:post, title: "Vim rules", inserted_at: dt.({2016, 3, 14}))
    Factory.insert!(:post, title: "Vim rules", inserted_at: dt.({2016, 3, 14}))

    visit(session, "/statistics")
    activity_tag = find(session, "ul#activity")
    thing = find(activity_tag, css("li[data-amount='1'][data-date='Mon, Mar 12']"))
    thing = find(activity_tag, css("li[data-amount='2'][data-date='Tue, Mar 13']"))
    thing = find(activity_tag, css("li[data-amount='3'][data-date='Wed, Mar 14']"))
  end
end
