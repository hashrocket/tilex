defmodule DeveloperEditsProfileTest do
  use Tilex.IntegrationCase, async: Application.get_env(:tilex, :async_feature_test)

  test "fills out form and updates post from post show", %{session: session} do
    developer = Factory.insert!(:developer, email: "fine@sixdollareggs.com")

    sign_in(session, developer)

    click(session, Query.link("Profile"))

    h1_heading = Element.text(find(session, Query.css("#profile_edit header h1")))
    profile_form = Element.text(find(session, Query.css("#profile_edit form")))

    assert h1_heading == "My Profile"
    assert profile_form =~ "fine@sixdollareggs.com"

    session
    |> fill_in(Query.text_field("Twitter handle"), with: "mcnormalmode")
    |> (fn(session) ->
      find(session, Query.select("Editor"), fn (element) ->
        click(element, Query.option("Vim"))
      end)
      session
    end).()
    |> click(Query.button("Submit"))

    element_text = fn (session, selector) ->
      Element.text(find(session, Query.css(selector)))
    end

    info_flash = element_text.(session, ".alert-info")

    assert info_flash == "Developer Updated"

    developer = Tilex.Developer
                |> Tilex.Repo.all
                |> Enum.reverse
                |> hd

    assert developer.twitter_handle == "mcnormalmode"
    assert developer.editor == "Vim"
  end
end
