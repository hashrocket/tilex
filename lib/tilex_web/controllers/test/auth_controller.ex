defmodule TilexWeb.Test.AuthController do
  use TilexWeb, :controller

  alias Guardian.Plug
  alias Tilex.{Developer, Repo}

  def index(conn, params) do
    developer = Repo.get_by!(Developer, id: params["id"])
    conn = Plug.sign_in(conn, developer)

    redirect(conn, to: "/")
  end
end
