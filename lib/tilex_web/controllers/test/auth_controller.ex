defmodule TilexWeb.Test.AuthController do
  use TilexWeb, :controller

  alias Tilex.Blog.Developer
  alias Tilex.Repo
  alias Tilex.Auth

  def index(conn, params) do
    developer = Repo.get_by!(Developer, id: params["id"])
    conn = Auth.Guardian.Plug.sign_in(conn, developer)

    redirect(conn, to: Routes.post_path(conn, :index))
  end
end
