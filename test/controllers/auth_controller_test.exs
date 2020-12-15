defmodule Tilex.AuthControllerTest do
  use TilexWeb.ConnCase, async: true

  alias Tilex.Factory

  test "GET /auth/google/callback with hashrocket email", %{conn: conn} do
    ueberauth_auth =
      ueberauth_struct("developer@hashrocket.com", "Ricky Rocketeer", "186823978541230597895")

    conn = assign(conn, :ueberauth_auth, ueberauth_auth)

    conn = get(conn, auth_path(conn, :callback, "google"))

    assert redirected_to(conn) == "/"
    assert get_flash(conn, :info) == "Signed in with developer@hashrocket.com"

    new_developer = Tilex.Repo.get_by!(Tilex.Developer, email: "developer@hashrocket.com")
    assert new_developer.email == "developer@hashrocket.com"
    assert new_developer.username == "rickyrocketeer"
  end

  test "GET /auth/google/callback with existing hashrocket email", %{conn: conn} do
    Factory.insert!(
      :developer,
      email: "rebecca@hashrocket.com",
      name: "Rebecca Rocketeer"
    )

    existing_developer = Tilex.Repo.get_by!(Tilex.Developer, email: "rebecca@hashrocket.com")
    assert existing_developer.email == "rebecca@hashrocket.com"

    ueberauth_auth =
      ueberauth_struct("rebecca@hashrocket.com", "Rebecca Rocketeer", "126456978541230597123")

    conn = assign(conn, :ueberauth_auth, ueberauth_auth)

    conn = get(conn, auth_path(conn, :callback, "google"))

    assert redirected_to(conn) == "/"
    assert get_flash(conn, :info) == "Signed in with rebecca@hashrocket.com"
  end

  test "GET /auth/google/callback with other email domain", %{conn: conn} do
    ueberauth_auth =
      ueberauth_struct("developer@gmail.com", "Rando Programmer", "186823978541230597895")

    conn = assign(conn, :ueberauth_auth, ueberauth_auth)

    conn = get(conn, auth_path(conn, :callback, "google"))

    assert redirected_to(conn) == "/"
    assert get_flash(conn, :info) == "developer@gmail.com is not a valid email address"
  end

  test "GET /auth/google/callback with nameless profile", %{conn: conn} do
    ueberauth_auth = ueberauth_struct("developer@gmail.com", nil, "186823978541230597895")

    conn = assign(conn, :ueberauth_auth, ueberauth_auth)

    conn = get(conn, auth_path(conn, :callback, "google"))

    assert redirected_to(conn) == "/"
    assert get_flash(conn, :info) == "oauth2 profile is missing a valid name"
  end

  test "GET /auth/google/callback with allowlisted email", %{conn: conn} do
    Application.put_env(:tilex, :guest_author_allowlist, "david@byrne.com, bell@thecat.com")

    ueberauth_auth =
      ueberauth_struct("bell@thecat.com", "Archibald Douglas", "186823978541230597895")

    conn = assign(conn, :ueberauth_auth, ueberauth_auth)

    conn = get(conn, auth_path(conn, :callback, "google"))

    assert redirected_to(conn) == "/"
    assert get_flash(conn, :info) == "Signed in with bell@thecat.com"
  end

  defp ueberauth_struct(email, name, uid) do
    %Ueberauth.Auth{
      info: %Ueberauth.Auth.Info{
        email: email,
        name: name
      },
      uid: uid
    }
  end
end
