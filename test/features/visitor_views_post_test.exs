defmodule VisitorViewsPostTest do
  use Tilex.IntegrationCase, async: true

  test "the page shows a post", %{session: session} do

    special = EctoFactory.insert(:post, title: "A special post")
    EctoFactory.insert(:post, title: "A random post")

    visit(session, "/posts/#{special.id}")

    body = session
                  |> find("body")
                  |> text

    assert body =~ ~r/A special post/
    refute body =~ ~r/A random post/
  end
end
