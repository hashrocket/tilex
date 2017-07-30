defmodule TilexWeb.AuthController do
  use TilexWeb, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case authenticate(auth) do
      {:ok, developer} ->
        conn = Guardian.Plug.sign_in(conn, developer)

        conn
        |> put_flash(:info, "Signed in with #{developer.email}")
        |> redirect(to: "/")
      {:error, email} when is_binary(email) ->
        conn
        |> put_flash(:info, "#{email} is not a valid email address")
        |> redirect(to: "/")
    end
  end

  def index(conn, _params) do
    redirect conn, to: "/auth/google"
  end

  def delete(conn, _params) do
    Guardian.Plug.sign_out(conn)
    |> put_flash(:info, "Signed out")
    |> redirect(to: "/")
  end

  defp authenticate(%{info: info, uid: uid}) do
    email = Map.get(info, :email)
    name  = Map.get(info, :name)

    case String.match?(email, ~r/@hashrocket.com$/) do
      true ->
        attrs = %{
          email: email,
          username: name,
          google_id: uid
        }

        Tilex.Developer.find_or_create(Tilex.Repo, attrs)
      _ ->
        {:error, email}
    end
  end
end
