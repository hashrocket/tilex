defmodule Tilex.Integration.Pages.CreatePostPage do
  use Wallaby.DSL

  def visit(session) do
    visit(session, "/posts/new")
  end

  def ensure_page_loaded(session) do
    session
    |> Browser.find(Query.css("main header h1", text: "Create Post"))

    session
  end

  def fill_in_form(session, fields \\ %{}) do
    session
    |> fill_in(Query.text_field("Title"), with: Map.get(fields, :title))
    |> fill_in(Query.text_field("Body"), with: Map.get(fields, :body))
    |> (fn(session) ->
      find(session, Query.select("Channel"), fn (element) ->
        click(element, Query.option(Map.get(fields, :channel)))
      end)
      session
    end).()
  end

  def submit_form(session) do
    session
    |> click(Query.button("Submit"))
  end

  def click_cancel(session) do
    session
    |> click(Query.link('cancel'))
  end

  def expect_form_has_error(session, error_text) do
    session
    |> Browser.find(Query.css("form", text: error_text))

    session
  end

  def expect_preview_content(session, tag, text) do
    session
    |> Browser.find(Query.css(".content_preview " <> tag, text: text))

    session
  end

  def expect_word_count(session, word_count) do
    session
    |> Browser.find(Query.css(".word_count", text: word_count |> to_string))

    session
  end

  def expect_words_left(session, text) do
    session
    |> Browser.find(Query.css(".word_limit", text: text))

    session
  end

  def expect_title_characters_left(session, text) do
    session
    |> Browser.find(Query.css(".character_limit", text: text))

    session
  end
end
