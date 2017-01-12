defmodule VisitorVisitsHomepageTest do
  use Tilex.IntegrationCase, async: true

  test "the page has the appropriate branding", %{session: session} do
    visit(session, "/")
    header = get_text(session, "h1 > a")

    assert header =~ ~r/Today I Learned/i
  end

  test "the page has a list of posts", %{session: session} do

    {:ok, channel} = Repo.insert(%Channel{name: "phoenix", twitter_hashtag: "phoenix"})

    Repo.insert(%Post{
      title: "A post about porting Rails applications to Phoenix",
      body: "It starts with Rails and ends with Elixir",
      channel_id: channel.id,
      slug: Post.generate_slug()
    })

    visit(session, "/")

    post_header = get_text(session, "article h1")
    post_body   = get_text(session, "article")
    post_footer = get_text(session, ".post aside")

    assert post_header == "A post about porting Rails applications to Phoenix"
    assert post_body   =~ ~r/It starts with Rails and ends with Elixir/
    assert post_footer =~ ~r/#phoenix/i
  end
end
