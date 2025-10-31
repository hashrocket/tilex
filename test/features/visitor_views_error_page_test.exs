defmodule VisitorViewsErrorPageTest do
  use Tilex.IntegrationCase, async: false

  describe "pages early rejected by url rule" do
    feature "shows not found error page", %{session: session} do
      session = visit(session, "/some-page.php")
      assert page_title(session) == "Not Found - Today I Learned"

      assert session
             |> find(Query.css("#home h1"))
             |> Element.text() == "…that there is no page at this URL!"
    end
  end

  describe "channel not found" do
    feature "shows not found error page", %{session: session} do
      session = visit(session, "/missing-channel")
      assert page_title(session) == "Not Found - Today I Learned"

      assert session
             |> find(Query.css("#home h1"))
             |> Element.text() == "…that there is no page at this URL!"
    end
  end
end
