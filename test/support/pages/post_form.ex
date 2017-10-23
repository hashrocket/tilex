defmodule Tilex.Integration.Pages.PostForm do
  use Wallaby.DSL
  import TilexWeb.Router.Helpers
  alias TilexWeb.Endpoint

  def navigate(session, post) do
    session
    |> visit(post_path(Endpoint, :edit, post))
  end

  def ensure_page_loaded(session) do
    session
    |> element_with_text?("main header h1", "Edit Post")
  end

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
    |> assert_has(Query.css(selector, text: text))

    session
  end

  def fill_in_title(session, title) do
    session
    |> fill_in(Query.text_field("Title"), with: title)
  end

  def fill_in_body(session, body) do
    session
    |> fill_in(Query.text_field("Body"), with: body)
  end

  def select_channel(session, name) do
    session
    |> (fn session ->
          find(session, Query.select("Channel"), fn element ->
            click(element, Query.option(name))
          end)

          session
        end).()
  end

  def click_submit(session) do
    session
    |> click(Query.button("Submit"))
  end
end
