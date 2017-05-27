defmodule DeveloperEditsPostTest do
  use Tilex.IntegrationCase, async: true

  alias Tilex.Integration.Pages.{
    PostForm
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

    sign_in(session, developer)

    visit(session, post_path(Endpoint, :show, post))

    click(session, Query.link("edit"))

    h1_heading = Element.text(find(session, Query.css("main header h1")))
    assert h1_heading == "Edit Post"

    session
    |> PostForm.expect_preview_content("em", "awesome")
    |> PostForm.expect_word_count(6)
    |> PostForm.expect_words_left("194 words available")
    |> PostForm.expect_title_characters_left("37 characters available")
    |> PostForm.expect_title_preview("Awesome Post!")

    session
    |> fill_in(Query.text_field("Title"), with: "Even Awesomer Post!")
    |> fill_in(Query.text_field("Body"), with: "This is how to be super awesome!")
    |> (fn(session) ->
      find(session, Query.select("Channel"), fn (element) ->
        click(element, Query.option("phoenix"))
      end)
      session
    end).()
    |> click(Query.button("Submit"))

    element_text = fn (session, selector) ->
      Element.text(find(session, Query.css(selector)))
    end

    info_flash       = element_text.(session, ".alert-info")
    post_title       = element_text.(session, ".post h1")
    post_body        = element_text.(session, ".post .copy")
    post_footer      = element_text.(session, ".post aside")
    likes_count      = element_text.(session, ".js-like-action")

    assert info_flash       == "Post Updated"
    assert post_title       =~ ~r/Even Awesomer Post!/
    assert post_body        =~ ~r/This is how to be super awesome!/
    assert post_footer      =~ ~r/#phoenix/i
    assert likes_count      =~ ~r/1/
  end
end
