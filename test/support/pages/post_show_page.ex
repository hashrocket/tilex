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

  defp assert_contains(session, query, expected_text) do
    texts = session |> Browser.all(query) |> Enum.map(&Element.text/1)

    ExUnit.Assertions.assert(
      Enum.any?(texts, &String.contains?(&1, expected_text)),
      "Unable to find contains text: '#{expected_text}', instead found '#{texts}'"
    )

    session
  end

  defp assert_texts(session, query, expected_texts) do
    texts = session |> Browser.all(query) |> Enum.map(&Element.text/1)

    ExUnit.Assertions.assert(
      texts == expected_texts,
      "Unable to find text: '#{expected_texts}', instead found '#{texts}'"
    )

    session
  end

  def expect_post_attributes(session, attrs \\ %{}) do
    expected_title = Map.fetch!(attrs, :title)
    expected_body = Map.fetch!(attrs, :body)
    expected_channel = attrs.channel
    expected_likes_count = attrs |> Map.fetch!(:likes_count) |> to_string()
    badge = attrs[:badge]

    session
    |> assert_texts(Query.css(".post h1"), [expected_title])
    |> assert_texts(Query.css(".post aside .post__tag-link"), [expected_channel])
    |> assert_contains(Query.css(".post .copy"), expected_body)
    |> assert_texts(Query.css(".post__like-count"), [expected_likes_count])
    |> then(fn s ->
      if badge do
        assert_texts(s, Query.css(".post__badge"), [badge])
      else
        s
      end
    end)
  end

  def click_edit(session) do
    click(session, Query.link("edit"))
  end
end
