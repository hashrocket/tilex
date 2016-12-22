defmodule VisitorVisitsHomepageTest do
  use Tilex.IntegrationCase

  test "the page has the appropriate branding" do
    navigate_to("/")

    assert visible_in_element?({:tag, "h1"}, ~r/Today I Learned/i)
  end

  test "the page has a list of posts" do
    post = EctoFactory.insert(:post,
      title: "A post about porting Rails applications to Phoenix",
      body: "It starts with Rails and ends with Elixir"
    )

    navigate_to("/")

    assert visible_in_page?(~r/A post about porting Rails applications to Phoenix/)
    assert visible_in_page?(~r/It starts with Rails and ends with Elixir/)
    assert visible_in_page?(~r/#{Timex.format!(post.inserted_at, "%B %-e, %Y", :strftime)}/)
  end
end
