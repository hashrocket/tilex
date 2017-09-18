defmodule AdminEditsPostTest do
  use Tilex.IntegrationCase, async: Application.get_env(:tilex, :async_feature_test)

  alias Tilex.Integration.Pages.{
    PostForm,
    PostShowPage
  }

  test "fills out form and updates post from post show", %{session: session} do
    Factory.insert!(:channel, name: "phoenix")
    developer = Factory.insert!(:developer)
    admin = Factory.insert!(:developer, %{admin: true})

    post = Factory.insert!(
      :post,
      title: "Awesome Post!",
      developer: developer,
      body: "This is how to be *awesome*!"
    )

    session
    |> sign_in(admin)
    |> PostForm.navigate(post)
    |> PostForm.ensure_page_loaded()
    |> PostForm.expect_title_preview("Awesome Post!")
    |> PostForm.fill_in_title("Even Awesomer Post!")
    |> PostForm.click_submit()

    session
    |> PostShowPage.ensure_page_loaded("Even Awesomer Post!")
  end
end
