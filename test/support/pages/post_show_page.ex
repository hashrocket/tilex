defmodule Tilex.Integration.Pages.PostShowPage do
  use Wallaby.DSL

  def navigate(session, post) do
    visit(session, "/posts/#{post.slug}")
  end

  def ensure_page_loaded(session, title) do
    session
    |> Browser.find(Query.css("article.post"))

    session
    |> Browser.find(Query.css("h1", text: title))

    session
  end

  def ensure_info_flash(session, message) do
    session
    |> Browser.find(Query.css(".alert-info", text: message))

    session
  end

  def expect_post_attributes(session, attrs \\ %{}) do
    expected_title = Map.fetch!(attrs, :title)
    expected_body = Map.fetch!(attrs, :body)
    expected_channel = Map.fetch!(attrs, :channel)
    expected_likes_count = Map.fetch!(attrs, :likes_count) |> to_string()

    session
    |> Browser.find(Query.css(".post h1", text: expected_title))

    session
    |> Browser.find(Query.css(".post .copy", text: expected_body))

    channel_name =
      session
      |> Browser.find(Query.css(".post aside .post__tag-link"))
      |> Element.text()

    ExUnit.Assertions.assert(
      channel_name =~ ~r/#{expected_channel}/i,
      "Unable to find text channel #{expected_channel}, instead found #{channel_name}"
    )

    session
    |> Browser.find(Query.css(".js-like-action", text: expected_likes_count))

    session
  end

  def click_edit(session) do
    click(session, Query.link("edit"))
  end
end
