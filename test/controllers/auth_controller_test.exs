defmodule Tilex.AuthControllerTest do
  use TilexWeb.ConnCase

  alias Tilex.Factory

  test "GET /auth/google/callback with hashrocket email", %{conn: conn} do
    ueberauth_auth =
      ueberauth_struct("developer@hashrocket.com",
                       "Ricky Rocketeer",
                       "186823978541230597895")

    conn = assign(conn, :ueberauth_auth, ueberauth_auth)

    conn = get conn, auth_path(conn, :callback, "google")

    assert redirected_to(conn) == "/"
    assert get_flash(conn, :info) == "Signed in with developer@hashrocket.com"

    new_developer =
      Tilex.Repo.get_by!(Tilex.Developer, google_id: "186823978541230597895")
    assert new_developer.email == "developer@hashrocket.com"
    assert new_developer.username == "rickyrocketeer"
  end

  test "GET /auth/google/callback with existing hashrocket email", %{conn: conn} do
    Factory.insert!(:developer,
                    email: "rebecca@hashrocket.com",
                    name: "Rebecca Rocketeer",
                    google_id: "126456978541230597123"
                  )
    existing_developer =
      Tilex.Repo.get_by!(Tilex.Developer, google_id: "126456978541230597123")
    assert existing_developer.email == "rebecca@hashrocket.com"

    ueberauth_auth =
      ueberauth_struct("rebecca@hashrocket.com",
                       "Rebecca Rocketeer",
                       "126456978541230597123")

    conn = assign(conn, :ueberauth_auth, ueberauth_auth)

    conn = get conn, auth_path(conn, :callback, "google")

    assert redirected_to(conn) == "/"
    assert get_flash(conn, :info) == "Signed in with rebecca@hashrocket.com"
  end

  test "GET /auth/google/callback with other email domain", %{conn: conn} do
    ueberauth_auth =
      ueberauth_struct("developer@gmail.com",
                       "Rando Programmer",
                       "186823978541230597895")

    conn = assign(conn, :ueberauth_auth, ueberauth_auth)

    conn = get conn, auth_path(conn, :callback, "google")

    assert redirected_to(conn) == "/"
    assert get_flash(conn, :info) == "developer@gmail.com is not a valid email address"
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
