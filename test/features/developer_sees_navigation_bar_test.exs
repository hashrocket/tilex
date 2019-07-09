defmodule DeveloperSeesNavigationBarTest do
  use Tilex.IntegrationCase, async: true

  alias Tilex.Integration.Pages.Navigation

  describe "when developer is not authenticated" do
    test "there is no link on admin navbar", %{session: session} do
      link_texts =
        session
        |> visit("/")
        |> get_texts(Navigation.item_query())

      assert link_texts == []
    end
  end

  describe "when developer is authenticated" do
    setup [:authenticated_developer]

    test "there are links on admin navbar", %{session: session} do
      link_texts =
        session
        |> visit("/")
        |> get_texts(Navigation.item_query())

      assert link_texts == ["Rock Teer", "Sign Out", "Create Post", "Profile"]
    end
  end
end
