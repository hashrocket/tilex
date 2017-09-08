defmodule Features.VisitorViewsChannelTest do
  use Tilex.IntegrationCase, async: Application.get_env(:tilex, :async_feature_test)

  test "sees associated posts", %{session: session} do
    target_channel = Factory.insert!(:channel, name: "phoenix")
    other_channel = Factory.insert!(:channel, name: "other")

    Enum.each(["i'm fine", "all these people out here", "what?"], fn(title) ->
      Factory.insert!(:post, title: title, channel: other_channel)
    end)
    Factory.insert!(:post, title: "functional programming rocks", channel: target_channel)

    visit(session, "/")
    assert find(session, Query.css("article.post", count: 4))
    click(session, Query.link("#phoenix"))

    page_header = Element.text(find(session, Query.css(".page_head")))

    assert page_header =~ ~r/1 post about #phoenix/
    assert find(session, Query.css("article.post"))
    assert page_title(session) == "Phoenix - Today I Learned"
  end

  test "the page has a list of paginated posts", %{session: session} do
    channel = Factory.insert!(:channel, name: "smalltalk")

    Enum.each(1..6, fn (x) ->
      Factory.insert!(:post,
        title: "Title#{x}",
        body: "It starts with Rails and ends with Elixir",
        channel: channel
      )
    end)

    session
    |> visit("/smalltalk")
    |> assert_has(Query.css("article.post", count: 5))
    |> assert_has(Query.css("nav.pagination", visible: true))
    |> visit("/smalltalk?page=2")
    |> assert_has(Query.css("h1", text: "Title1", visible: true))
    |> assert_has(Query.css("article.post", count: 1))
    |> visit("/smalltalk")
    |> assert_has(Query.css("h1", text: "Title5", visible: true))
    |> assert_has(Query.css("article.post", count: 5))
  end
end
