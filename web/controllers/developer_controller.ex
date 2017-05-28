defmodule Tilex.DeveloperController do
  use Tilex.Web, :controller

  alias Tilex.Developer

  def show(conn, %{"name" => username} = params) do
    page = Map.get(params, "page", "1") |> String.to_integer

    {posts, posts_count, developer} = Tilex.Posts.by_developer(username, page)

    render(conn, "show.html",
      posts: posts,
      posts_count: posts_count,
      developer: developer,
      page: page
    )
  end

  def edit(conn, _params) do
    developer = Guardian.Plug.current_resource(conn)

    changeset = Developer.changeset(developer)

    render(conn, "edit.html", developer: developer, changeset: changeset)
  end

  def update(conn, %{"developer" => developer_params}) do
    developer = Guardian.Plug.current_resource(conn)

    changeset = Developer.changeset(developer, developer_params)

    case Repo.update(changeset) do
      {:ok, developer} ->
        conn
        |> put_flash(:info, "Developer Updated")
        |> redirect(to: post_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", developer: developer, changeset: changeset)
    end
  end
end
