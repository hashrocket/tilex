defmodule Tilex.Notifications do
  @slack_notifier Application.get_env(:tilex, :slack_notifier)
  @twitter_notifier Application.get_env(:tilex, :twitter_notifier)

  use GenServer

  alias Ecto.{Changeset, DateTime}
  alias Tilex.{Post, Repo}
  alias TilexWeb.Endpoint
  alias TilexWeb.Router.Helpers

  ### Client API

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Alert the notification system that a new post has been created
  """
  def post_created(%Post{} = post) do
    GenServer.cast(__MODULE__, {:post_created, post})
  end

  @doc """
  Alert the notification system that a post has been liked
  """
  def post_liked(%Post{} = post, max_likes_changed) do
    GenServer.cast(__MODULE__, {:post_liked, post, max_likes_changed})
  end

  ### Server API

  def init(_) do
    {:ok, :nostate}
  end

  def handle_cast({:post_created, %Post{} = post}, :nostate) do
    developer = Repo.one(Ecto.assoc(post, :developer))
    channel = Repo.one(Ecto.assoc(post, :channel))
    url = Helpers.post_url(Endpoint, :show, post)

    @slack_notifier.notify(post, developer, channel, url)
    @twitter_notifier.notify(post, developer, channel, url)

    post_changeset = Changeset.change(post, %{tweeted_at: DateTime.utc})
    Repo.update!(post_changeset)

    {:noreply, :nostate}
  end

  def handle_cast({:post_liked, %Post{max_likes: max_likes} = post, max_likes_changed}, :nostate) do
    if rem(max_likes, 10) == 0 and max_likes_changed do
      developer = Repo.one(Ecto.assoc(post, :developer))
      url = Helpers.post_url(Endpoint, :show, post)

      @slack_notifier.notify_of_awards(post, developer, url)
    end

    {:noreply, :nostate}
  end
end
