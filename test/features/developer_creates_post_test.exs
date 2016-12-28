defmodule DeveloperCreatesPostTest do
  use Tilex.IntegrationCase, async: true

  alias Tilex.Post

  test "fills out form and submits", %{session: session} do

    EctoFactory.insert(:channel, name: "phoenix", twitter_hashtag: "phoenix")

    visit(session, "/posts/new")
    h1_heading = get_text(session, "main header h1")
    assert h1_heading == "Create Post"

    fill_in(session, "post_title", with: "Example Title")
    fill_in(session, "post_body", with: "Example Body")
    Wallaby.DSL.Actions.select(session, "Channel", option: "phoenix")
    click_on(session, 'Submit')

    post = Enum.reverse(Tilex.Repo.all(Post)) |> hd
    assert post.body == "Example Body"
    assert post.title == "Example Title"

    index_h1_heading = get_text(session, "header.site_head div h1")
    page_body        = get_text(session, "body")
    post_footer      = get_text(session, ".post aside")

    assert index_h1_heading =~ ~r/Today I Learned/i
    assert page_body        =~ ~r/Example Title/
    assert page_body        =~ ~r/Example Body/
    assert post_footer      =~ ~r/#phoenix/i
  end
end
