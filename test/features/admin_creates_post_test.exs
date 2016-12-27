defmodule AdminCreatesPostTest do
  use Tilex.IntegrationCase, async: true

  alias Tilex.Post

  test "fills out form and submits", %{session: session} do
    visit(session, "/posts/new")
    h1_heading = session |> find("main header h1") |> text
    assert h1_heading == "Create Post"

    fill_in(session, "post_title", with: "Example Title")
    fill_in(session, "post_body", with: "Example Body")
    click_on(session, 'Submit')

    post = Enum.reverse(Tilex.Repo.all(Post)) |> hd
    assert post.body == "Example Body"
    assert post.title == "Example Title"

    index_h1_heading = session |> find("header.site_head div h1") |> text
    page_body = session |> find("body") |> text

    assert index_h1_heading =~ ~r/Today I Learned/i
    assert page_body =~ ~r/Example Title/
    assert page_body =~ ~r/Example Body/
  end
end
