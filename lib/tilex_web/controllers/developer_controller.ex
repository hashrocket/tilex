defmodule TilexWeb.DeveloperController do
  use TilexWeb, :controller

  alias Guardian.Plug
  alias Tilex.{Developer, Posts, Repo}

  def show(conn, %{"name" => username} = params) do
    page =
      params
      |> Map.get("page", "1")
      |> String.to_integer()

    {posts, posts_count, developer} = Posts.by_developer(username, page)

    render(
      conn,
      "show.html",
      posts: posts,
      posts_count: posts_count,
      developer: developer,
      page: page
    )
  end

  def edit(conn, _params) do
    developer = Plug.current_resource(conn)
    changeset = Developer.changeset(developer)

    render(conn, "edit.html", developer: developer, changeset: changeset)
  end

  def update(conn, %{"developer" => developer_params}) do
    developer = Plug.current_resource(conn)

    changeset = Developer.changeset(developer, developer_params)

    case Repo.update(changeset) do
      {:ok, _developer} ->
        conn
        |> put_flash(:info, "Developer Updated")
        |> redirect(to: post_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", developer: developer, changeset: changeset)
    end
  end
end
