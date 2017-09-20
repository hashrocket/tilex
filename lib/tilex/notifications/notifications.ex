defmodule Tilex.Notifications do
  use GenServer

  alias Ecto.{Changeset, DateTime}
  alias Tilex.{Post, Repo}
  alias TilexWeb.Endpoint
  alias TilexWeb.Router.Helpers
  alias Tilex.Notifications.NotifiersSupervisor

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

    notifiers()
    |> Enum.each(&(&1.post_created(post, developer, channel, url)))

    post_changeset = Changeset.change(post, %{tweeted_at: DateTime.utc})
    Repo.update!(post_changeset)

    {:noreply, :nostate}
  end

  def handle_cast({:post_liked, %Post{max_likes: max_likes} = post, max_likes_changed}, :nostate) do
    if rem(max_likes, 10) == 0 and max_likes_changed do
      developer = Repo.one(Ecto.assoc(post, :developer))
      url = Helpers.post_url(Endpoint, :show, post)

      notifiers()
      |> Enum.each(&(&1.post_liked(post, developer, url)))
    end

    {:noreply, :nostate}
  end

  def notifiers(notifiers_supervisor \\ NotifiersSupervisor) do
    notifiers_supervisor.children()
  end
end
