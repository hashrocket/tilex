defmodule DeveloperCreatesPostTest do
  use Tilex.IntegrationCase, async: Application.get_env(:tilex, :async_feature_test)

  alias Tilex.Integration.Pages.{
    Navigation,
    IndexPage,
    CreatePostPage,
    PostShowPage,
    PostForm
  }

  test "fills out form and submits", %{session: session} do
    Ecto.Adapters.SQL.Sandbox.allow(Tilex.Repo, self(), Process.whereis(Tilex.Notifications))
    Factory.insert!(:channel, name: "phoenix")
    developer = Factory.insert!(:developer)

    session
    |> sign_in(developer)
    |> IndexPage.navigate()
    |> IndexPage.ensure_page_loaded()
    |> Navigation.click_create_post()
    |> CreatePostPage.ensure_page_loaded()
    |> CreatePostPage.fill_in_form(%{
      title: "Example Title",
      body: "Example Body",
      channel: "phoenix"
    })
    |> CreatePostPage.submit_form()
    |> PostShowPage.ensure_info_flash("Post created")
    |> PostShowPage.ensure_page_loaded("Example Title")
    |> PostShowPage.expect_post_attributes(%{
      title: "Example Title",
      body: "Example Body",
      channel: "phoenix",
      likes_count: 1
    })

    post =
      Post
      |> Repo.all()
      |> Enum.reverse()
      |> hd

    assert post.body == "Example Body"
    assert post.title == "Example Title"
    refute is_nil(post.tweeted_at)

    session
    |> Navigation.ensure_heading("TODAY I LEARNED")
  end

  test "cancels submission", %{session: session} do
    developer = Factory.insert!(:developer)

    session
    |> sign_in(developer)
    |> CreatePostPage.navigate()
    |> CreatePostPage.ensure_page_loaded()
    |> CreatePostPage.click_cancel()
    |> IndexPage.ensure_page_loaded()
  end

  test "fails to enter things", %{session: session} do
    developer = Factory.insert!(:developer)

    session
    |> sign_in(developer)
    |> CreatePostPage.navigate()
    |> CreatePostPage.ensure_page_loaded()
    |> CreatePostPage.submit_form()
    |> CreatePostPage.ensure_page_loaded()
    |> CreatePostPage.expect_form_has_error("Title can't be blank")
    |> CreatePostPage.expect_form_has_error("Body can't be blank")
    |> CreatePostPage.expect_form_has_error("Channel can't be blank")
  end

  test "enters a title that is too long", %{session: session} do
    Factory.insert!(:channel, name: "phoenix")
    developer = Factory.insert!(:developer)

    session
    |> sign_in(developer)
    |> CreatePostPage.navigate()
    |> CreatePostPage.ensure_page_loaded()
    |> CreatePostPage.fill_in_form(%{
      title: String.duplicate("I can codez ", 10),
      body: "Example Body",
      channel: "phoenix"
    })
    |> CreatePostPage.submit_form()
    |> CreatePostPage.ensure_page_loaded()
    |> CreatePostPage.expect_form_has_error("Title should be at most 50 character(s)")
  end

  test "enters a body that is too long", %{session: session} do
    Factory.insert!(:channel, name: "phoenix")
    developer = Factory.insert!(:developer)

    session
    |> sign_in(developer)
    |> CreatePostPage.navigate()
    |> CreatePostPage.ensure_page_loaded()
    |> CreatePostPage.fill_in_form(%{
      title: "Example Title",
      body: String.duplicate("wordy ", 201),
      channel: "phoenix"
    })
    |> CreatePostPage.submit_form()
    |> CreatePostPage.ensure_page_loaded()
    |> CreatePostPage.expect_form_has_error("Body should be at most 200 word(s)")
  end

  test "enters markdown code into the body", %{session: session} do
    Factory.insert!(:channel, name: "phoenix")
    developer = Factory.insert!(:developer)

    session
    |> sign_in(developer)
    |> CreatePostPage.navigate()
    |> CreatePostPage.ensure_page_loaded()
    |> CreatePostPage.fill_in_form(%{
      title: "Example Title",
      body: "**bold powerup**",
      channel: "phoenix"
    })

    assert find(session, Query.css("strong", text: "bold powerup"))
  end

  test "views parsed markdown preview", %{session: session} do
    Factory.insert!(:channel, name: "phoenix")
    developer = Factory.insert!(:developer)

    session
    |> sign_in(developer)
    |> CreatePostPage.navigate()
    |> CreatePostPage.ensure_page_loaded()
    |> CreatePostPage.fill_in_form(%{
      title: "Example Title",
      body: "# yay \n *cool*",
      channel: "phoenix"
    })
    |> PostForm.expect_preview_content("h1", "yay")
    |> PostForm.expect_preview_content("em", "cool")
    |> PostForm.expect_word_count(3)
    |> PostForm.expect_words_left("197 words available")
    |> PostForm.expect_title_characters_left("37 characters available")
    |> PostForm.expect_title_preview("Example Title")
  end

  test "fills out form with a common language fenced code block", %{session: session} do
    Ecto.Adapters.SQL.Sandbox.allow(Tilex.Repo, self(), Process.whereis(Tilex.Notifications))
    Factory.insert!(:channel, name: "ruby")
    developer = Factory.insert!(:developer)

    session
    |> sign_in(developer)
    |> IndexPage.navigate()
    |> IndexPage.ensure_page_loaded()
    |> Navigation.click_create_post()
    |> CreatePostPage.ensure_page_loaded()
    |> CreatePostPage.fill_in_form(%{
      title: "Example Title",
      body: "```ruby\ndef test; end\n```",
      channel: "ruby"
    })
    |> CreatePostPage.submit_form()
    |> PostShowPage.ensure_info_flash("Post created")
    |> PostShowPage.ensure_page_loaded("Example Title")
    |> PostShowPage.expect_fenced_code_block(%{
      header: "ruby",
      code: "ruby"
    })
  end

  test "fills out form with a made-up language fenced code block", %{session: session} do
    Ecto.Adapters.SQL.Sandbox.allow(Tilex.Repo, self(), Process.whereis(Tilex.Notifications))
    Factory.insert!(:channel, name: "madeuplang")
    developer = Factory.insert!(:developer)

    session
    |> sign_in(developer)
    |> IndexPage.navigate()
    |> IndexPage.ensure_page_loaded()
    |> Navigation.click_create_post()
    |> CreatePostPage.ensure_page_loaded()
    |> CreatePostPage.fill_in_form(%{
      title: "Example Title",
      body: "```madeuplang\ndefn testly; end\n```",
      channel: "madeuplang"
    })
    |> CreatePostPage.submit_form()
    |> PostShowPage.ensure_info_flash("Post created")
    |> PostShowPage.ensure_page_loaded("Example Title")
    |> PostShowPage.expect_fenced_code_block(%{
      header: "madeuplang",
      code: "madeuplang"
    })
  end

  test "fills out form with an inferred language fenced code block", %{session: session} do
    Ecto.Adapters.SQL.Sandbox.allow(Tilex.Repo, self(), Process.whereis(Tilex.Notifications))
    Factory.insert!(:channel, name: "ruby")
    developer = Factory.insert!(:developer)

    session
    |> sign_in(developer)
    |> IndexPage.navigate()
    |> IndexPage.ensure_page_loaded()
    |> Navigation.click_create_post()
    |> CreatePostPage.ensure_page_loaded()
    |> CreatePostPage.fill_in_form(%{
      title: "Example Title",
      body: "```\ndef obviously_ruby; puts 'Ruby is great'; end\n```",
      channel: "ruby"
    })
    |> CreatePostPage.submit_form()
    |> PostShowPage.ensure_info_flash("Post created")
    |> PostShowPage.ensure_page_loaded("Example Title")
    |> PostShowPage.expect_fenced_code_block(%{
      header: "ruby",
      code: "ruby"
    })
  end
end
