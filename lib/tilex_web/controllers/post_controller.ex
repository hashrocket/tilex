defmodule TilexWeb.PostController do

  @moduledoc """
    Provides functions to manage posts.
  """

  use TilexWeb, :controller
  import Ecto.Query

  plug :load_channels when action in [:new, :create, :edit, :update]
  plug :extract_slug when action in [:show, :edit, :update]

  plug Guardian.Plug.EnsureAuthenticated, [handler: __MODULE__] when action in [:new, :create, :edit, :update]

  def unauthenticated(conn, _) do
    conn
    |> put_status(302)
    |> put_flash(:info, "Authentication required")
    |> redirect(to: "/")
  end

  alias Tilex.{Post, Channel, Posts}

  def index(conn, %{"q" => search_query} = params) do
    page = Map.get(params, "page", "1") |> String.to_integer
    {posts, posts_count} = Posts.by_search(search_query, page)
    render(conn, "search_results.html",
      posts: posts,
      posts_count: posts_count,
      page: page,
      query: search_query
    )
  end

  def index(conn, %{"format" => format}) when format in ~w(rss atom), do: redirect(conn, to: "/rss")

  def index(conn, params) do
    page = Map.get(params, "page", "1") |> String.to_integer
    posts = Posts.all(page)

    render(conn, "index.html", posts: posts, page: page)
  end

  def show(conn, _) do
    post = Repo.get_by!(Post, slug: conn.assigns.slug)
           |> Repo.preload([:channel])
           |> Repo.preload([:developer])

    canonical_post = Application.get_env(:tilex, :canonical_domain) <> post_path(conn, :show, post)

    assign(conn, :canonical_url, canonical_post)
    |> render("show.html", post: post)
  end

  def random(conn, _) do
    query = from post in Post,
      order_by: fragment("random()"),
      limit: 1,
      preload: [:channel, :developer]

    post = Repo.one(query)

    render(conn, "show.html", post: post)
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{})
    render conn, "new.html", changeset: changeset
  end

  def like(conn, %{"slug" => slug}) do
    likes = Tilex.Liking.like(slug)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{likes: likes}))
  end

  def unlike(conn, %{"slug" => slug}) do
    likes = Tilex.Liking.unlike(slug)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{likes: likes}))
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
        |> Tilex.Integrations.notify(post)

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    post = case current_user.admin do
      false -> current_user
           |> assoc(:posts)
           |> Repo.get_by!(slug: conn.assigns.slug)
      true -> Repo.get_by!(Post, slug: conn.assigns.slug)
    end

    changeset = Post.changeset(post)

    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"post" => post_params}) do
    current_user = Guardian.Plug.current_resource(conn)

    post = case current_user.admin do
      false -> current_user
           |> assoc(:posts)
           |> Repo.get_by!(slug: conn.assigns.slug)
      true -> Repo.get_by!(Post, slug: conn.assigns.slug)
    end

    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post Updated")
        |> redirect(to: post_path(conn, :show, post))
      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  defp load_channels(conn, _) do
    query = Channel
    |> Channel.names_and_ids
    |> Channel.alphabetized

    channels = Repo.all(query)
    assign(conn, :channels, channels)
  end

  defp extract_slug(conn, _) do
    case extracted_slug(conn.params["titled_slug"]) do
      {:ok, slug} ->
        assign(conn, :slug, slug)
      :error ->
        conn
        |> put_status(404)
        |> render(TilexWeb.ErrorView, "404.html")
        |> halt()
    end
  end

  defp extracted_slug(<<slug::size(10)-binary, _rest::binary>>), do: {:ok, slug}
  defp extracted_slug(_), do: :error
end
