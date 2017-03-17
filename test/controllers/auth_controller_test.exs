defmodule Tilex.AuthControllerTest do
  use Tilex.ConnCase#, async: true

  alias Tilex.Factory

  test "GET /auth/google/callback with hashrocket email", %{conn: conn} do
    ueberauth_auth = %Ueberauth.Auth{
      info: %Ueberauth.Auth.Info{
        email: "developer@hashrocket.com",
        first_name: "Ricky",
        last_name: "Rocketeer",
        name: "Ricky Rocketeer"
      },
      uid: "186823978541230597895"
    }
    conn =
      conn
      |> assign(:ueberauth_auth, ueberauth_auth)

    conn = get conn, auth_path(conn, :callback, "google")

    assert redirected_to(conn) == "/"

    flash_info =
      conn
      |> Map.get(:private)
      |> Map.get(:phoenix_flash)
      |> Map.get("info")
    assert flash_info == "Signed in with developer@hashrocket.com"

    new_developer =
      Tilex.Repo.get_by!(Tilex.Developer, google_id: "186823978541230597895")
    assert new_developer.email == "developer@hashrocket.com"
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

    ueberauth_auth = %Ueberauth.Auth{
      info: %Ueberauth.Auth.Info{
        email: "rebecca@hashrocket.com",
        first_name: "Rebecca",
        last_name: "Rocketeer",
        name: "Rebecca Rocketeer"
      },
      uid: "126456978541230597123"
    }
    conn =
      conn
      |> assign(:ueberauth_auth, ueberauth_auth)

    conn = get conn, auth_path(conn, :callback, "google")

    assert redirected_to(conn) == "/"

    flash_info =
      conn
      |> Map.get(:private)
      |> Map.get(:phoenix_flash)
      |> Map.get("info")
    assert flash_info == "Signed in with rebecca@hashrocket.com"
  end

  test "GET /auth/google/callback with other email domain", %{conn: conn} do
    ueberauth_auth = %Ueberauth.Auth{
      info: %Ueberauth.Auth.Info{
        email: "developer@gmail.com",
        first_name: "Rando",
        last_name: "Programmer",
        name: "Rando Programmer"
      },
      uid: "186823978541230597895"
    }
    conn =
      conn
      |> assign(:ueberauth_auth, ueberauth_auth)

    conn = get conn, auth_path(conn, :callback, "google")

    assert redirected_to(conn) == "/"
    assert Map.get(conn, :private) |> Map.get(:phoenix_flash) == %{"info" => "developer@gmail.com is not a valid email address"}
  end
end
