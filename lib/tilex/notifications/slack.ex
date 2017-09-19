defmodule Tilex.Notifications.Slack do
  @emoji ~w(
    :tada:
    :birthday:
    :sparkles:
    :boom:
    :hearts:
    :balloon:
    :crown:
    :mortar_board:
    :trophy:
    :100:
  )

  use GenServer

  ### Client API

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Post a message to Slack that a new post has been created
  """
  def post_created(post, developer, channel, url) do
    GenServer.cast(__MODULE__, {:post_created, post, developer, channel, url})
  end

  @doc """
  Post a message to Slack that a post has been liked
  """
  def post_liked(post, developer, url) do
    GenServer.cast(__MODULE__, {:post_liked, post, developer, url})
  end

  ### Server Callbacks

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:post_created, post, developer, channel, url}, state) do
    "#{developer.username} created a new post <#{url}|#{post.title}> ##{channel.name}"
    |> send_slack_message

    {:noreply, state}
  end

  def handle_cast({:post_liked, %Tilex.Post{max_likes: max_likes, title: title}, developer, url}, state) do
    appropriate_emoji = @emoji
    |> Enum.at(round((max_likes / 10) - 1), ":smile:")

    "#{developer.username}'s post has #{max_likes} likes! #{appropriate_emoji} - <#{url}|#{title}>"
    |> send_slack_message

    {:noreply, state}
  end

  defp send_slack_message(message) do
    endpoint = System.get_env("slack_post_endpoint")
    HTTPoison.post("https://hooks.slack.com" <> endpoint, "{\"text\": \"#{message}\"}")
  end
end
