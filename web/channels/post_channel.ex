defmodule Tilex.PostChannel do
  use Phoenix.Channel
  alias Tilex.Repo
  import Ecto.Query
  alias Tilex.Channel
  alias Tilex.Post

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
               Tilex.PostView,
               "search_results.html",
               %{posts: posts, conn: Tilex.Endpoint, query: query}
             )

    push socket, "search", %{html: html}
    {:noreply, socket}
  end
end
