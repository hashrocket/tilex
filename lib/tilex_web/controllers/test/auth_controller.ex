defmodule TilexWeb.Test.AuthController do
  use TilexWeb, :controller

  alias Tilex.{Developer, Repo, Guardian}

  def index(conn, params) do
    developer = Repo.get_by!(Developer, id: params["id"])
    conn = Guardian.Plug.sign_in(conn, developer)

    redirect(conn, to: post_path(conn, :index))
  end
end
