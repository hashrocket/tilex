defmodule Tilex.Integration.Pages.Navigation do
  use Wallaby.DSL

  def ensure_heading(session, text) do
    heading =
      session
      |> Browser.find(Query.css("header.site_head div h1"))
      |> Element.text()

    ExUnit.Assertions.assert(heading =~ ~r/#{text}/i, "Expected: #{text}, Found: #{heading}")

    session
  end

  def click_create_post(session) do
    click(session, Query.link("Create Post"))
  end

  @spec item_query() :: Query.t()
  def item_query(), do: Query.css("nav.admin_panel a")
end
