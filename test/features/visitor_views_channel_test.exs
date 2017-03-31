defmodule Features.VisitorViewsChannelTest do
  use Tilex.IntegrationCase, async: true

  test "sees associated posts", %{session: session} do

    target_channel = Factory.insert!(:channel, name: "phoenix")
    other_channel = Factory.insert!(:channel, name: "other")

    Factory.insert!(:post, title: "functional programming rocks", channel: target_channel)

    Enum.each(["i'm fine", "all these people out here", "what?"], fn(title) ->
      Factory.insert!(:post, title: title, channel: other_channel)
    end)

    visit(session, "/")
    assert find(session, Query.css("article.post", count: 4))
    click(session, Query.link("#phoenix"))

    page_header = Element.text(find(session, Query.css(".page_head")))

    assert page_header =~ ~r/1 post about #phoenix/
    assert find(session, Query.css("article.post"))
  end

  test "the page has a list of paginated posts", %{session: session} do

    channel = Factory.insert!(:channel, name: "smalltalk")

    Factory.insert_list!(:post, 5 + 1,
      title: "A post about porting Rails applications to Phoenix",
      body: "It starts with Rails and ends with Elixir",
      channel: channel
    )

    visit(session, "/smalltalk")

    assert find(session, Query.css("article.post", count: 5))

    assert find(session, Query.css("nav.pagination", visible: true))
    click(session, Query.link("older TILs"))

    assert find(session, Query.css("article.post", count: 1))

    click(session, Query.link("newer TILs"))

    assert find(session, Query.css("article.post", count: 5))
  end
end
