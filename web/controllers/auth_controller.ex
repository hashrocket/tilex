defmodule Tilex.AuthController do
  use Tilex.Web, :controller
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    conn
    |> put_flash(:info, "Signed in")
    |> redirect(to: "/")
  end

  def index(conn, _params) do
    redirect conn, to: "/auth/google"
  end
end
