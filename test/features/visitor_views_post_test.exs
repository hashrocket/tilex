defmodule VisitorViewsPostTest do
  use Tilex.IntegrationCase, async: true

  test "the page shows a post", %{session: session} do

    {:ok, channel} = Repo.insert(%Channel{name: "elixir", twitter_hashtag: "myelixirstatus"})
    {:ok, special} = Repo.insert(%Post{
      title: "A special post",
      body: "irrelevant",
      channel_id: channel.id,
      slug: Post.generate_slug(),
    })

    Repo.insert(%Post{
      title: "A random post",
      body: "irrelevant",
      channel_id: channel.id,
      slug: Post.generate_slug(),
    })

    visit(session, "/posts/#{special.slug}")

    body = get_text(session, "body")

    assert body =~ ~r/A special post/
    refute body =~ ~r/A random post/
  end
end
