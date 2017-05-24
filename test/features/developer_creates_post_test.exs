defmodule DeveloperCreatesPostTest do
  use Tilex.IntegrationCase, async: true

  alias Tilex.Integration.Pages.{
    Navigation,
    IndexPage,
    CreatePostPage,
    PostShowPage
  }

  test "fills out form and submits", %{session: session} do
    Factory.insert!(:channel, name: "phoenix")
    developer = Factory.insert!(:developer)

    sign_in(session, developer)

    session
    |> IndexPage.visit()
    |> IndexPage.ensure_page_loaded()

    session
    |> Navigation.click_create_post()

    session
    |> CreatePostPage.ensure_page_loaded()
    |> CreatePostPage.fill_in_form(%{
      title:  "Example Title",
      body: "Example Body",
      channel: "phoenix"
    })
    |> CreatePostPage.submit_form()

    post = Enum.reverse(Tilex.Repo.all(Post)) |> hd
    assert post.body == "Example Body"
    assert post.title == "Example Title"
    refute is_nil(post.tweeted_at)

    session
    |> PostShowPage.ensure_page_loaded(post)
    |> PostShowPage.ensure_info_flash("Post created")
    |> PostShowPage.expect_post_attributes(%{
      title: "Example Title",
      body: "Example Body",
      channel: "phoenix",
      likes_count: 1
    })

    session
    |> Navigation.ensure_heading("TODAY I LEARNED")
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
