defmodule DeveloperEditsPostTest do
  use Tilex.IntegrationCase, async: Application.get_env(:tilex, :async_feature_test)

  alias Tilex.Integration.Pages.{
    PostForm,
    PostShowPage
  }

  test "fills out form and updates post from post show", %{session: session} do
    Factory.insert!(:channel, name: "phoenix")
    developer = Factory.insert!(:developer)
    post = Factory.insert!(
      :post,
      title: "Awesome Post!",
      developer: developer,
      body: "This is how to be *awesome*!"
    )

    session
    |> sign_in(developer)
    |> PostShowPage.navigate(post)
    |> PostShowPage.click_edit()

    session
    |> PostForm.ensure_page_loaded()
    |> PostForm.expect_preview_content("em", "awesome")
    |> PostForm.expect_word_count(6)
    |> PostForm.expect_words_left("194 words available")
    |> PostForm.expect_title_characters_left("37 characters available")
    |> PostForm.expect_title_preview("Awesome Post!")
    |> PostForm.fill_in_title("Even Awesomer Post!")
    |> PostForm.fill_in_body("This is how to be super awesome!")
    |> PostForm.select_channel("phoenix")
    |> PostForm.click_submit()

    session
    |> PostShowPage.ensure_page_loaded("Even Awesomer Post!")
    |> PostShowPage.ensure_info_flash("Post Updated")
    |> PostShowPage.expect_post_attributes(%{
      title: "Even Awesomer Post!",
      body: "This is how to be super awesome!",
      channel: "#phoenix",
      likes_count: 1
    })
  end
end
