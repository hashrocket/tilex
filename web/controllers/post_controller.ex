defmodule Tilex.PostController do
  use Tilex.Web, :controller

  plug :load_channels when action in [:new, :create]

  alias Tilex.Post
  alias Tilex.Channel

  def index(conn, _params) do
    posts = Repo.all from p in Post,
      order_by: [desc: p.inserted_at],
      join: c in assoc(p, :channel),
      preload: [channel: c]
    render(conn, "index.html", posts: posts)
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
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
