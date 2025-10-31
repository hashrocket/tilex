defmodule AdminEditsPostTest do
  use Tilex.IntegrationCase, async: false

  alias Tilex.Integration.Pages.PostForm
  alias Tilex.Integration.Pages.PostShowPage

  feature "fills out form and updates post from post show", %{session: session} do
    Factory.insert!(:channel, name: "phoenix")
    developer = Factory.insert!(:developer, %{username: "luke-skywalker"})
    admin = Factory.insert!(:developer, %{admin: true, username: "darth-vader"})

    post =
      Factory.insert!(
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
    |> PostForm.click_save()

    session
    |> PostShowPage.ensure_page_loaded("Even Awesomer Post!")
  end

  feature "enters a title that is too long", %{session: session} do
    Factory.insert!(:channel, name: "phoenix")
    developer = Factory.insert!(:developer)

    post =
      Factory.insert!(
        :post,
        title: "Limited characters",
        developer: developer,
        body: "Bugs revealed"
      )

    session
    |> sign_in(developer)
    |> PostForm.navigate(post)
    |> PostForm.ensure_page_loaded()
    |> PostForm.fill_in_title(String.duplicate("I can codez ", 10))
    |> PostForm.click_save()

    session
    |> PostForm.expect_form_has_error("Title should be at most 50 character(s)")
  end
end
