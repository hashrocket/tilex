defmodule Tilex.AuthControllerTest do
  use Tilex.ConnCase#, async: true

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
    assert Map.get(conn, :private) |> Map.get(:phoenix_flash) == %{"info" => "Signed in with developer@hashrocket.com"}
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
