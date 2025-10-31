defmodule DeveloperDeletesPostTest do
  use Tilex.IntegrationCase, async: false

  alias Tilex.Blog.Post
  alias Tilex.Integration.Pages.PostShowPage
  alias Tilex.Repo

  feature "developer can delete their own post", %{session: session} do
    developer = Factory.insert!(:developer)
    post = Factory.insert!(:post, developer: developer)

    session
    |> sign_in(developer)
    |> PostShowPage.navigate(post)
    |> click_and_confirm(Query.link("delete"))
    |> assert_flash(:info, "Post deleted successfully")
    |> assert_path(developer_path(TilexWeb.Endpoint, :show, developer))

    assert Repo.all(Post) == []
  end

  feature "admin can delete other developer's post", %{session: session} do
    developer = Factory.insert!(:developer, username: "regular-dev")
    admin = Factory.insert!(:developer, username: "admin-user", admin: true)
    post = Factory.insert!(:post, developer: developer)

    session
    |> sign_in(admin)
    |> PostShowPage.navigate(post)
    |> click_and_confirm(Query.link("delete"))
    |> assert_flash(:info, "Post deleted successfully")
    |> assert_path(developer_path(TilexWeb.Endpoint, :show, developer))

    assert Repo.all(Post) == []
  end

  feature "non-owner cannot see delete button", %{session: session} do
    developer = Factory.insert!(:developer, username: "post-owner")
    other_developer = Factory.insert!(:developer, username: "other-dev")
    post = Factory.insert!(:post, developer: developer)

    session
    |> sign_in(other_developer)
    |> PostShowPage.navigate(post)
    |> refute_has(Query.link("delete"))
  end
end
