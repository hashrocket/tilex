defmodule VisitorViewsPostTest do
  use Tilex.IntegrationCase, async: true

  test "the page shows a post", %{session: session} do

    Factory.insert!(:post, title: "A special post")

    body = visit(session, "/")
      |> click_link("permalink")
      |> get_text("body")

    assert body =~ ~r/A special post/
  end

  test "and sees marketing copy, if it exists", %{session: session} do

    marketing_channel = Factory.insert!(:channel, name: "elixir")
    post_in_marketing_channel = Factory.insert!(:post, channel: marketing_channel)

    copy = visit(session, post_path(Endpoint, :show, post_in_marketing_channel.slug))
      |> get_text(".more-info")

    {:ok, marketing_content} = File.read("web/templates/shared/_elixir.html.eex")
    assert copy =~ String.slice(marketing_content, 0, 10)
  end
end
