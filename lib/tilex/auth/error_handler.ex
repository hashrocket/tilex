defmodule Tilex.Auth.ErrorHandler do
  import TilexWeb.Router.Helpers
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_failure_type, _reason}, _opts) do
    conn
    |> Tilex.Auth.Guardian.Plug.sign_out()
    |> put_flash(:info, "Authentication required")
    |> redirect(to: post_path(conn, :index))
  end
end
