defmodule TilexWeb.AuthController do
  use TilexWeb, :controller
  plug(Ueberauth)

  alias Tilex.{Developer, Repo, Auth}

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case authenticate(auth) do
      {:ok, developer} ->
        conn = Auth.Guardian.Plug.sign_in(conn, developer)

        conn
        |> put_flash(:info, "Signed in with #{developer.email}")
        |> redirect(to: post_path(conn, :index))

      {:error, reason} ->
        conn
        |> put_flash(:info, reason)
        |> redirect(to: post_path(conn, :index))
    end
  end

  def index(conn, _params) do
    redirect(conn, to: auth_path(conn, :request, "google"))
  end

  def delete(conn, _params) do
    conn
    |> Auth.Guardian.Plug.sign_out()
    |> put_flash(:info, "Signed out")
    |> redirect(to: post_path(conn, :index))
  end

  defp authenticate(%{info: %{email: email, name: name}}) when is_binary(name) do
    case authorized(email) do
      {:ok, email} ->
        attrs = %{
          email: email,
          username: Developer.format_username(name)
        }

        Developer.find_or_create(Repo, attrs)

      _ ->
        {:error, "#{email} is not a valid email address"}
    end
  end

  defp authenticate(_), do: {:error, "oauth2 profile is missing a valid name"}

  defp authorized(email) do
    cond do
      String.match?(email, ~r/@#{hosted_domain()}$/) -> {:ok, email}
      email in guest_allowlist() -> {:ok, email}
      true -> {:error, email}
    end
  end

  defp hosted_domain, do: Application.get_env(:tilex, :hosted_domain)

  defp guest_allowlist do
    with emails when is_binary(emails) <- Application.get_env(:tilex, :guest_author_allowlist),
         allowlist <- String.split(emails, [",", " "], trim: true) do
      allowlist
    else
      _ -> []
    end
  end
end
