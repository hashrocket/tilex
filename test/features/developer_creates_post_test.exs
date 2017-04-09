defmodule DeveloperCreatesPostTest do
  use Tilex.IntegrationCase, async: true

  test "fills out form and submits", %{session: session} do

    Factory.insert!(:channel, name: "phoenix")
    developer = Factory.insert!(:developer)

    sign_in(session, developer)

    visit(session, "/")
    click(session, Query.link("Create Post"))

    h1_heading = Element.text(find(session, Query.css("main header h1")))
    assert h1_heading == "Create Post"

    session
    |> fill_in(Query.text_field("Title"), with: "Example Title")
    |> fill_in(Query.text_field("Body"), with: "Example Body")
    |> (fn(session) ->
      find(session, Query.select("Channel"), fn (element) ->
        click(element, Query.option("phoenix"))
      end)
      session
    end).()
    |> click(Query.button("Submit"))

    post = Enum.reverse(Tilex.Repo.all(Post)) |> hd
    assert post.body == "Example Body"
    assert post.title == "Example Title"

    element_text = fn (session, selector) ->
      Element.text(find(session, Query.css(selector)))
    end

    index_h1_heading = element_text.(session, "header.site_head div h1")
    info_flash       = element_text.(session, ".alert-info")
    post_title       = element_text.(session, ".post h1")
    session |> take_screenshot()
    post_body        = element_text.(session, ".post .copy")
    post_footer      = element_text.(session, ".post aside")
    likes_count      = element_text.(session, ".js-like-action")

    assert index_h1_heading =~ ~r/Today I Learned/i
    assert info_flash       == "Post created"
    assert post_title       =~ ~r/Example Title/
    assert post_body        =~ ~r/Example Body/
    assert post_footer      =~ ~r/#phoenix/i
    assert likes_count      =~ ~r/1/
  end

  test "cancels submission", %{session: session} do

    developer = Factory.insert!(:developer)

    session
    |> sign_in(developer)
    |> visit("/posts/new")
    |> click(Query.link('cancel'))

    path = current_path(session)

    assert path == "/"
  end

  test "fails to enter things", %{session: session} do

    developer = Factory.insert!(:developer)

    session
    |> sign_in(developer)
    |> visit("/posts/new")
    |> click(Query.button("Submit"))

    body = Element.text(find(session, Query.css("body")))

    assert body =~ ~r/Title can't be blank/
    assert body =~ ~r/Body can't be blank/
    assert body =~ ~r/Channel can't be blank/
  end

  test "enters a title that is too long", %{session: session} do

    developer = Factory.insert!(:developer)

    session
    |> sign_in(developer)
    |> visit("/posts/new")
    |> fill_in(Query.text_field("Title"), with: String.duplicate("I can codez ", 10))
    |> click(Query.button("Submit"))

    body = Element.text(find(session, Query.css("body")))

    assert body =~ ~r/Title should be at most 50 character\(s\)/
  end

  test "enters a body that is too long", %{session: session} do
    developer = Factory.insert!(:developer)

    session
    |> sign_in(developer)
    |> visit("/posts/new")
    |> fill_in(Query.text_field("Body"), with: String.duplicate("wordy ", 201))
    |> click(Query.button("Submit"))

    body = Element.text(find(session, Query.css("body")))

    assert body =~ ~r/Body should be at most 200 word\(s\)/
  end

  @tag :skip
  test "enters markdown code into the body", %{session: session} do

    Factory.insert!(:channel, name: "phoenix")

    session
    |> visit("/posts/new")
    |> fill_in(Query.text_field("Title"), with: "Example Title")
    |> fill_in(Query.text_field("Body"), with: "`code`")
    |> (fn(session) ->
      find(session, Query.select("Channel"), fn (element) ->
        click(element, Query.option("phoenix"))
      end)
      session
    end).()
    |> click(Query.button("Submit"))

    assert find(session, Query.css("code", text: "code"))
  end
end
