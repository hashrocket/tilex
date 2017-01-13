defmodule VisitorViewsPostTest do
  use Tilex.IntegrationCase, async: true

  test "the page shows a post", %{session: session} do

    special = Factory.insert!(:post, title: "A special post")
    Factory.insert!(:post, title: "A random post")

    visit(session, "/posts/#{special.slug}")

    body = get_text(session, "body")

    assert body =~ ~r/A special post/
    refute body =~ ~r/A random post/
  end
end
