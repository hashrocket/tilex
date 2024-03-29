defmodule TilexWeb.PostController do
  use TilexWeb, :controller
  import Tilex.Pageable
  import Ecto.Query
  import TilexWeb.StructuredDataView, only: [post_ld: 2]

  alias Tilex.Blog.Channel
  alias Tilex.Notifications
  alias Tilex.Liking
  alias Tilex.Blog.Post
  alias Tilex.Posts

  plug(:load_channels when action in [:new, :create, :edit, :update])
  plug(:extract_slug when action in [:show, :edit, :update])

  plug(
    Guardian.Plug.EnsureAuthenticated,
    [error_handler: __MODULE__]
    when action in ~w(new create edit update)a
  )

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_failure_type, _reason}, _opts) do
    conn
    |> put_status(302)
    |> put_flash(:info, "Authentication required")
    |> redirect(to: Routes.post_path(conn, :index))
  end

  def index(conn, %{"q" => search_query} = params) do
    page = robust_page(params)
    {posts, posts_count} = Posts.by_search(search_query, page)

    conn
    |> assign(:meta_robots, "noindex")
    |> render(
      "search_results.html",
      posts: posts,
      posts_count: posts_count,
      page: page,
      query: search_query
    )
  end

  def index(conn, %{"format" => format}) when format in ~w(rss atom),
    do: redirect(conn, to: Routes.feed_path(conn, :index))

  def index(conn, params) do
    page = robust_page(params)
    posts = Posts.all(page)

    conn =
      case page do
        1 -> conn
        _ -> assign(conn, :meta_robots, "noindex")
      end

    render(conn, "index.html", posts: posts, page: page)
  end

  def show(%{assigns: %{slug: slug}} = conn, _) do
    post =
      Post
      |> Repo.get_by!(slug: slug)
      |> Repo.preload([:channel])
      |> Repo.preload([:developer])

    conn
    |> assign(:twitter_shareable, true)
    |> assign(:structured_data_ld, post_ld(conn, post))
    |> render(:show, post: post)
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
    |> assign(:meta_robots, "noindex")
    |> assign(:twitter_shareable, true)
    |> render("show.html", post: post)
  end

  def new(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
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
    |> send_resp(200, Jason.encode!(%{likes: likes}))
  end

  def unlike(conn, %{"slug" => slug}) do
    likes = Liking.unlike(slug)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(%{likes: likes}))
  end

  def create(conn, %{"post" => params}) do
    developer = Guardian.Plug.current_resource(conn)

    sanitized_params =
      params
      |> post_params()
      |> Map.merge(%{"developer_id" => developer.id})

    changeset = Post.changeset(%Post{}, sanitized_params)

    case Repo.insert(changeset) do
      {:ok, post} ->
        Notifications.post_created(post)

        conn
        |> put_flash(:info, "Post created")
        |> redirect(to: Routes.post_path(conn, :index))

      {:error, changeset} ->
        conn
        |> assign(:current_user, developer)
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  def edit(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

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

  def update(conn, %{"post" => params}) do
    current_user = Guardian.Plug.current_resource(conn)

    post =
      case current_user.admin do
        false ->
          current_user
          |> assoc(:posts)
          |> Repo.get_by!(slug: conn.assigns.slug)

        true ->
          Repo.get_by!(Post, slug: conn.assigns.slug)
      end

    sanitized_params = post_params(params)

    changeset = Post.changeset(post, sanitized_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post Updated")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset, current_user: current_user)
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
        TilexWeb.ErrorView.render_error_page(conn, 404)
    end
  end

  defp extracted_slug(<<slug::size(10)-binary, _rest::binary>>), do: {:ok, slug}
  defp extracted_slug(_), do: :error

  defp post_params(params) do
    Map.take(params, ["body", "channel_id", "title"])
  end
end
