defmodule Tilex.PostChannel do
  use Phoenix.Channel
  import Ecto.Query

  alias Tilex.{Repo, Post, PostView, Endpoint}

  def join("post:search", _message, socket) do
    {:ok, socket}
  end

  def join("post:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("search", %{"query" => query}, socket) do
    channel_query = Channel
    |> Channel.names_and_ids
    |> Channel.alphabetized

    channels = Repo.all(channel_query)

    posts = Repo.all from p in Post,
      join: c in assoc(p, :channel),
      preload: [channel: c],
      where: ilike(p.title, ^"%#{query}%")

      html = Phoenix.View.render_to_string(
               PostView,
               "search_results.html",
               %{posts: posts, conn: Endpoint, query: query}
             )

    push socket, "search", %{html: html}
    {:noreply, socket}
  end
end
