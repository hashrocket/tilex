defmodule Tilex.PostController do
  use Tilex.Web, :controller

  plug :load_channels when action in [:new, :create]

  alias Tilex.{Post, Channel}

  def index(conn, params) do
    page = Map.get(params, "page", "1") |> String.to_integer
    posts = Tilex.Posts.all(page)
    render(conn, "index.html", posts: posts, page: page)
  end

  def show(conn, %{"titled_slug" => titled_slug}) do
    [slug|_] = titled_slug |> String.split("-")
    post = Repo.get_by!(Post, slug: slug)
           |> Repo.preload([:channel])
    render(conn, "show.html", post: post)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"post" => post_params}) do
    changeset = Post.changeset(%Post{}, post_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Post created")
        |> redirect(to: post_path(conn, :index))
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
