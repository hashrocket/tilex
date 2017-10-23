defmodule Tilex.Integration.Pages.CreatePostPage do
  use Wallaby.DSL

  def navigate(session) do
    visit(session, "/posts/new")
  end

  def ensure_page_loaded(session) do
    session
    |> assert_has(Query.css("main header h1", text: "Create Post"))

    session
  end

  def fill_in_form(session, fields \\ %{}) do
    session
    |> fill_in(Query.text_field("Title"), with: Map.get(fields, :title))
    |> fill_in(Query.text_field("Body"), with: Map.get(fields, :body))
    |> (fn session ->
          find(session, Query.select("Channel"), fn element ->
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
    |> assert_has(Query.css("form", text: error_text))

    session
  end
end
