defmodule TilexWeb.Test.AuthController do

  @moduledoc """
    Provides support for Tilex statistics.
  """

  use TilexWeb, :controller

  def index(conn, params) do
    developer = Tilex.Repo.get_by!(Tilex.Developer, id: params["id"])
    conn = Guardian.Plug.sign_in(conn, developer)

    redirect(conn, to: "/")
  end
end
