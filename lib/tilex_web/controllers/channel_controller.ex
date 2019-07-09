defmodule TilexWeb.ChannelController do
  use TilexWeb, :controller

  alias Tilex.Posts
  alias Tilex.Channel
  alias Tilex.Repo

  plug(
    Guardian.Plug.EnsureAuthenticated,
    [error_handler: __MODULE__]
    when action in ~w(index new create edit update delete)a
  )

  def auth_error(conn, {_failure_type, _reason}, _opts) do
    conn
    |> put_status(302)
    |> put_flash(:info, "Authentication required")
    |> redirect(to: post_path(conn, :index))
  end

  def show(conn, %{"name" => channel_name} = params) do
    page =
      params
      |> Map.get("page", "1")
      |> String.to_integer()

    {posts, posts_count, channel} = Posts.by_channel(channel_name, page)

    render(
      conn,
      "show.html",
      posts: posts,
      posts_count: posts_count,
      channel: channel,
      page: page
    )
  end

  def index(conn, _params) do
    query =
      from(c in Channel,
        left_join: p in assoc(c, :posts),
        group_by: c.id,
        select: {c, count(p.channel_id)},
        order_by: [asc: c.name]
      )

    channels = Repo.all(query)

    render(conn, "index.html", channels: channels)
  end

  def new(conn, _params) do
    changeset = Channel.changeset(%Channel{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"channel" => channel_params}) do
    changeset = Channel.changeset(%Channel{}, channel_params)

    case Repo.insert(changeset) do
      {:ok, _channel} ->
        conn
        |> put_flash(:info, "Channel created successfully.")
        |> redirect(to: channel_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    channel = Repo.get!(Channel, id)
    changeset = Channel.changeset(channel)
    render(conn, "edit.html", channel: channel, changeset: changeset)
  end

  def update(conn, %{"id" => id, "channel" => channel_params}) do
    channel = Repo.get!(Channel, id)
    changeset = Channel.changeset(channel, channel_params)

    case Repo.update(changeset) do
      {:ok, _channel} ->
        conn
        |> put_flash(:info, "Channel updated successfully.")
        |> redirect(to: channel_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", channel: channel, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    channel = Repo.get!(Channel, id)
    {:ok, _channel} = Repo.delete(channel)

    conn
    |> put_flash(:info, "Channel deleted successfully.")
    |> redirect(to: channel_path(conn, :index))
  end
end
