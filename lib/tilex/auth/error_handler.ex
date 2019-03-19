defmodule Tilex.Auth.ErrorHandler do
  import Plug.Conn
  import TilexWeb.Router.Helpers
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_failure_type, _reason}, _opts) do
    conn
    |> put_status(302)
    |> put_flash(:info, "Authentication required")
    |> redirect(to: post_path(conn, :index))
  end
end
