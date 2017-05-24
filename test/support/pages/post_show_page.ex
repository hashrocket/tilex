defmodule Tilex.Integration.Pages.PostShowPage do
  use Wallaby.DSL

  def ensure_page_loaded(session, post) do
    session
    |> Browser.find(Query.css("#post_show"))

    session
    |> Browser.find(Query.css("h1", text: post.title))

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

    session
    |> Browser.find(Query.css(".post aside .post__tag-link", text: String.upcase(expected_channel)))

    session
    |> Browser.find(Query.css(".js-like-action", text: expected_likes_count))

    session
  end
end
