defmodule TilexWeb.AuthController do
  use TilexWeb, :controller
  plug(Ueberauth)

  alias Guardian.Plug
  alias Tilex.{Developer, Repo}

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case authenticate(auth) do
      {:ok, developer} ->
        conn = Plug.sign_in(conn, developer)

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
    redirect(conn, to: "/auth/google")
  end

  def delete(conn, _params) do
    conn
    |> Plug.sign_out()
    |> put_flash(:info, "Signed out")
    |> redirect(to: "/")
  end

  defp authenticate(%{info: info, uid: uid}) do
    email = Map.get(info, :email)
    name = Developer.format_username(Map.get(info, :name))

    case String.match?(email, ~r/@#{Application.get_env(:tilex, :hosted_domain)}$/) do
      true ->
        attrs = %{
          email: email,
          username: name,
          google_id: uid
        }

        Developer.find_or_create(Repo, attrs)

      _ ->
        {:error, email}
    end
  end
end
