defmodule Features.VisitorViewsChannelTest do
  use Tilex.IntegrationCase, async: true

  test "sees associated posts", %{session: session} do

    target_channel = EctoFactory.insert(:channel, name: "phoenix")
    other_channel  = EctoFactory.insert(:channel, name: "other")

    EctoFactory.insert(:post,
      title: "functional programming rocks",
      channel_id: target_channel.id,
      slug: Tilex.Post.generate_slug(),
    )

    Enum.each(["i'm fine", "all these people out here", "what?"], fn(title) ->
      EctoFactory.insert(:post,
        title: title,
        channel_id: other_channel.id,
        slug: Tilex.Post.generate_slug(),
      )
    end)

    visit(session, "/")
    assert find(session, "article.post", count: 4)
    click_link(session, "#phoenix")

    page_header = get_text(session, ".page_head")

    assert page_header =~ ~r/1 post about #phoenix/
    assert find(session, "article.post", count: 1)
  end
end
