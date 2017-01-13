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
    assert find(session, "article.post", count: 4)
    click_link(session, "#phoenix")

    page_header = get_text(session, ".page_head")

    assert page_header =~ ~r/1 post about #phoenix/
    assert find(session, "article.post", count: 1)
  end
end
