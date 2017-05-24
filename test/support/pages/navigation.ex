defmodule Tilex.Integration.Pages.Navigation do
  use Wallaby.DSL

  def ensure_heading(session, text) do
    session
    |> Browser.find(Query.css("header.site_head div h1", text: text))

    session
  end

  def click_create_post(session) do
    click(session, Query.link("Create Post"))
  end
end
