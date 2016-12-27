defmodule VisitorVisitsHomepageTest do
  use Tilex.IntegrationCase, async: true

  test "the page has the appropriate branding", %{session: session} do
    visit(session, "/")
    header = session
              |> find("h1 > a") 
              |> text

    assert header =~ ~r/Today I Learned/i
  end

  test "the page has a list of posts", %{session: session} do
    EctoFactory.insert(:post,
      title: "A post about porting Rails applications to Phoenix",
      body: "It starts with Rails and ends with Elixir"
    )

    visit(session, "/")

    post_header = session
                  |> find("article h1")
                  |> text

    post = session
            |> find("article")
            |> text

    assert post_header == "A post about porting Rails applications to Phoenix"
    assert post =~ ~r/It starts with Rails and ends with Elixir/
  end
end
