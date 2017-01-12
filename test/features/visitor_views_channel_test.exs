defmodule Features.VisitorViewsChannelTest do
  use Tilex.IntegrationCase, async: true

  alias Tilex.{Channel, Post, Repo}

  test "sees associated posts", %{session: session} do

    {:ok, target_channel} = Repo.insert(%Channel{name: "phoenix", twitter_hashtag: "phoenix"})
    {:ok, other_channel}  = Repo.insert(%Channel{name: "other", twitter_hashtag: "phoenix"})

    Repo.insert(%Post{
      title: "functional programming rocks",
      body: "irrelevant",
      channel_id: target_channel.id,
      slug: Post.generate_slug(),
    })

    Enum.each(["i'm fine", "all these people out here", "what?"], fn(title) ->
      Repo.insert(%Post{
        title: title,
        body: "irrelevant",
        channel_id: other_channel.id,
        slug: Post.generate_slug(),
      })
    end)

    visit(session, "/")
    assert find(session, "article.post", count: 4)
    click_link(session, "#phoenix")

    page_header = get_text(session, ".page_head")

    assert page_header =~ ~r/1 post about #phoenix/
    assert find(session, "article.post", count: 1)
  end
end
