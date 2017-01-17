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

  test "and sees marketing copy, if it exists", %{session: session} do

    marketing_focus_channel = Factory.insert!(:channel, name: "elixir")
    marketing_focus_post = Factory.insert!(:post, channel: marketing_focus_channel)
    assert File.exists?("web/templates/shared/_elixir.html.eex")

    copy = visit(session, "/posts/#{marketing_focus_post.slug}")
      |> get_text(".more-info")

    assert copy =~ "Looking for help?"
  end
end
