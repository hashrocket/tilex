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

      {:error, reason} ->
        conn
        |> put_flash(:info, reason)
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
      email in guest_whitelist() -> {:ok, email}
      true -> {:error, email}
    end
  end

  defp hosted_domain, do: Application.get_env(:tilex, :hosted_domain)

  defp guest_whitelist do
    with emails when is_binary(emails) <- Application.get_env(:tilex, :guest_author_whitelist),
         whitelist <- String.split(emails, [",", " "], trim: true) do
      whitelist
    else
      _ -> []
    end
  end
end
