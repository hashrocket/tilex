defmodule Tilex.Notifications.Twitter do
  alias Tilex.Developer

  use GenServer

  ### Client API

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Post a message to Twitter that a new post has been created
  """
  def post_created(post, developer, channel, url) do
    GenServer.cast(__MODULE__, {:post_created, post, developer, channel, url})
  end

  ### Server Callbacks

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:post_created, post, developer, channel, url}, state) do
    "#{post.title} #{url} via @#{Developer.twitter_handle(developer)} #til ##{channel.twitter_hashtag}"
    |> send_tweet

    {:noreply, state}
  end

  def send_tweet(text) do
    ExTwitter.update(text)
  end
end
