defmodule AdminCreatesPostTest do
  use Tilex.IntegrationCase, async: true

  alias Tilex.Post

  test "fills out form and submits" do
    navigate_to("/posts/new")
    h1_heading = find_element(:css, "main header h1")
    assert inner_text(h1_heading) =~ "Create Post"

    title = find_element(:name, "post[title]")
    body = find_element(:name, "post[body]")
    button = find_element(:tag, "button")

    fill_field(title, "Example Title")
    fill_field(body, "Example Body")
    click(button)

    post = Enum.reverse(Tilex.Repo.all(Post)) |> hd
    assert post.body == "Example Body"
    assert post.title == "Example Title"

    index_h1_heading = find_element(:css, "header.site_head div h1")

    assert inner_text(index_h1_heading) =~ ~r/Today I Learned/i
    assert visible_in_page?(~r/Example Title/)
    assert visible_in_page?(~r/Example Body/)
  end
end
