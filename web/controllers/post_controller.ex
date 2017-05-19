defmodule Tilex.PostController do
  use Tilex.Web, :controller

  plug :load_channels when action in [:new, :create]

  plug Guardian.Plug.EnsureAuthenticated, [handler: __MODULE__] when action in [:new, :create]

  def unauthenticated(conn, _) do
    conn
    |> put_status(302)
    |> put_flash(:info, "Authentication required")
    |> redirect(to: "/")
  end

  alias Tilex.{Post, Channel}

  def index(conn, params) do
    page = Map.get(params, "page", "1") |> String.to_integer
    posts = Tilex.Posts.all(page)
    render(conn, "index.html", posts: posts, page: page)
  end

  def show(conn, %{"titled_slug" => titled_slug}) do
    [slug | _] = titled_slug |> String.split("-")

    post = Repo.get_by!(Post, slug: slug)
           |> Repo.preload([:channel])
           |> Repo.preload([:developer])

    render(conn, "show.html", post: post)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"post" => post_params}) do
    developer = Guardian.Plug.current_resource(conn)

    changeset =
      %Post{}
      |> Map.put(:developer_id, developer.id)
      |> Post.changeset(post_params)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created")
        |> redirect(to: post_path(conn, :index))
        |> Tilex.Integrations.post_notifications(post)

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  defp load_channels(conn, _) do
    query = Channel
    |> Channel.names_and_ids
    |> Channel.alphabetized

    channels = Repo.all(query)
    assign(conn, :channels, channels)
  end
end
