defmodule Tilex.Integration.Pages.IndexPage do
  use Wallaby.DSL

  def navigate(session) do
    visit(session, "/")
  end

  def ensure_page_loaded(session) do
    session
    |> Browser.find(Query.css("#home"))

    session
  end
end
