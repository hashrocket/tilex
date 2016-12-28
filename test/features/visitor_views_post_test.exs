defmodule VisitorViewsPostTest do
  use Tilex.IntegrationCase, async: true

  test "the page shows a post", %{session: session} do

    channel = EctoFactory.insert(:channel)
    special = EctoFactory.insert(:post, title: "A special post", channel_id: channel.id)
    EctoFactory.insert(:post, title: "A random post", channel_id: channel.id)

    visit(session, "/posts/#{special.id}")

    body = get_text(session, "body")

    assert body =~ ~r/A special post/
    refute body =~ ~r/A random post/
  end
end
