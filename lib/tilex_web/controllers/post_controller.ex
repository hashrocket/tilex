defmodule TilexWeb.PostController do
  use TilexWeb, :controller
  import Ecto.Query

  alias Guardian.Plug
  alias Phoenix.Controller
  alias Tilex.{Channel, Notifications, Liking, Post, Posts}

  plug(:load_channels when action in [:new, :create, :edit, :update])
  plug(:extract_slug when action in [:show, :edit, :update])

  plug(
    Plug.EnsureAuthenticated,
    [handler: __MODULE__]
    when action in ~w(new create edit update)a
  )

  def unauthenticated(conn, _) do
    conn
    |> put_status(302)
    |> put_flash(:info, "Authentication required")
    |> redirect(to: "/")
  end

  def index(conn, %{"q" => search_query} = params) do
    page =
      params
      |> Map.get("page", "1")
      |> String.to_integer()

    {posts, posts_count} = Posts.by_search(search_query, page)

    render(
      conn,
      "search_results.html",
      posts: posts,
      posts_count: posts_count,
      page: page,
      query: search_query
    )
  end

  def index(conn, %{"format" => format}) when format in ~w(rss atom),
    do: redirect(conn, to: "/rss")

  def index(conn, params) do
    page =
      params
      |> Map.get("page", "1")
      |> String.to_integer()

    posts = Posts.all(page)

    render(conn, "index.html", posts: posts, page: page)
  end

  def show(%{assigns: %{slug: slug}} = conn, _) do
    format = Controller.get_format(conn)

    post =
      Post
      |> Repo.get_by!(slug: slug)
      |> Repo.preload([:channel])
      |> Repo.preload([:developer])

    conn
    |> assign_post_canonical_url(post)
    |> assign(:twitter_shareable, true)
    |> render("show.#{format}", post: post)
  end

  def random(conn, _) do
    query =
      from(
        post in Post,
        order_by: fragment("random()"),
        limit: 1,
        preload: [:channel, :developer]
      )

    post = Repo.one(query)

    conn
    |> assign_post_canonical_url(post)
    |> assign(:twitter_shareable, true)
    |> render("show.html", post: post)
  end

  def new(conn, _params) do
    current_user = Plug.current_resource(conn)
    changeset = Post.changeset(%Post{})

    conn
    |> assign(:changeset, changeset)
    |> assign(:current_user, current_user)
    |> render("new.html")
  end

  def like(conn, %{"slug" => slug}) do
    likes = Liking.like(slug)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{likes: likes}))
  end

  def unlike(conn, %{"slug" => slug}) do
    likes = Liking.unlike(slug)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Poison.encode!(%{likes: likes}))
  end

  def create(conn, %{"post" => post_params}) do
    developer = Plug.current_resource(conn)

    changeset =
      %Post{}
      |> Map.put(:developer_id, developer.id)
      |> Post.changeset(post_params)

    case Repo.insert(changeset) do
      {:ok, post} ->
        Notifications.post_created(post)

        conn
        |> put_flash(:info, "Post created")
        |> redirect(to: post_path(conn, :index))

      {:error, changeset} ->
        conn
        |> assign(:current_user, developer)
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  def edit(conn, _params) do
    current_user = Plug.current_resource(conn)

    post =
      case current_user.admin do
        false ->
          current_user
          |> assoc(:posts)
          |> Repo.get_by!(slug: conn.assigns.slug)

        true ->
          Repo.get_by!(Post, slug: conn.assigns.slug)
      end

    changeset = Post.changeset(post)

    conn
    |> assign(:post, post)
    |> assign(:changeset, changeset)
    |> assign(:current_user, current_user)
    |> render("edit.html")
  end

  def update(conn, %{"post" => post_params}) do
    current_user = Plug.current_resource(conn)

    post =
      case current_user.admin do
        false ->
          current_user
          |> assoc(:posts)
          |> Repo.get_by!(slug: conn.assigns.slug)

        true ->
          Repo.get_by!(Post, slug: conn.assigns.slug)
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
    query =
      Channel
      |> Channel.names_and_ids()
      |> Channel.alphabetized()

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

  defp assign_post_canonical_url(conn, post) do
    canonical_post =
      :tilex
      |> Application.get_env(:canonical_domain)
      |> URI.merge(post_path(conn, :show, post))
      |> URI.to_string()

    conn
    |> assign(:canonical_url, canonical_post)
  end
end
