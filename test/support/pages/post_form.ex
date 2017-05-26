defmodule Tilex.Integration.Pages.PostForm do
  use Wallaby.DSL

  def expect_preview_content(session, tag, text) do
    session
    |> element_with_text?(".content_preview #{tag}", text)
  end

  def expect_word_count(session, word_count) do
    session
    |> element_with_text?(".word_count", word_count |> to_string)
  end

  def expect_words_left(session, text) do
    session
    |> element_with_text?(".word_limit", text)
  end

  def expect_title_characters_left(session, text) do
    session
    |> element_with_text?(".character_limit", text)
  end

  def expect_title_preview(session, title) do
    session
    |> element_with_text?(".title_preview", title)
  end

  defp element_with_text?(session, selector, text) do
    session
    |> Browser.find(Query.css(selector, text: text))

    session
  end
end
