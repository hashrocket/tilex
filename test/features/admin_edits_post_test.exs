defmodule AdminEditsPostTest do
  use Tilex.IntegrationCase, async: Application.get_env(:tilex, :async_feature_test)

  alias Tilex.Integration.Pages.{
    PostForm
  }

  alias Tilex.Web.Endpoint

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

    sign_in(session, admin)

    visit(session, post_path(Endpoint, :show, post))

    click(session, Query.link("edit"))

    h1_heading = Element.text(find(session, Query.css("main header h1")))
    assert h1_heading == "Edit Post"

    session
    |> PostForm.expect_title_preview("Awesome Post!")

    session
    |> fill_in(Query.text_field("Title"), with: "Even Awesomer Post!")
    |> click(Query.button("Submit"))

    element_text = fn (session, selector) ->
      Element.text(find(session, Query.css(selector)))
    end

    post_title = element_text.(session, ".post h1")

    assert post_title       =~ ~r/Even Awesomer Post!/
  end
end
