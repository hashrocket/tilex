defmodule TilexWeb.DeveloperController do
  use TilexWeb, :controller
  import Tilex.Pageable
  alias Tilex.Blog.Developer
  alias Tilex.Posts
  alias Tilex.Repo
  alias Tilex.Auth

  def show(conn, %{"name" => username} = params) do
    page = robust_page(params)
    {posts, posts_count, developer} = Posts.by_developer(username, page)

    conn
    |> assign(:meta_robots, "noindex")
    |> render(
      "show.html",
      posts: posts,
      posts_count: posts_count,
      developer: developer,
      page: page
    )
  end

  def edit(conn, _params) do
    developer = Auth.Guardian.Plug.current_resource(conn)
    changeset = Developer.changeset(developer)

    render(conn, "edit.html", developer: developer, changeset: changeset)
  end

  def update(conn, %{"developer" => developer_params}) do
    developer = Auth.Guardian.Plug.current_resource(conn)

    changeset = Developer.changeset(developer, developer_params)

    case Repo.update(changeset) do
      {:ok, _developer} ->
        conn
        |> put_flash(:info, "Developer Updated")
        |> redirect(to: Routes.post_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", developer: developer, changeset: changeset)
    end
  end
end
