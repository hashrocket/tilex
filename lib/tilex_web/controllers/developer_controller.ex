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

  def generate_api_key(conn, _params) do
    developer = Auth.Guardian.Plug.current_resource(conn)

    %{
      mcp_api_key: mcp_api_key,
      signed_token: signed_token
    } = Developer.generate_mcp_api_key(TilexWeb.Endpoint)

    developer
    |> Developer.mcp_api_key_changeset(mcp_api_key)
    |> Repo.update()
    |> case do
      {:ok, %Developer{} = developer} ->
        conn
        |> put_flash(
          :info,
          "API key generated successfully. Save it securely - you won't be able to see it again!"
        )
        |> render("edit.html",
          developer: developer,
          changeset: Developer.changeset(developer),
          mcp_signed_token: signed_token
        )

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Failed to generate API key. Please try again.")
        |> redirect(to: Routes.developer_path(conn, :edit))
    end
  end
end
