defmodule Tilex.Notifications.Notifiers.Bluesky do
  alias BlueskyEx.Client
  alias Tilex.Blog.Developer

  use Tilex.Notifications.Notifier

  def handle_post_created(post, developer, channel, url) do
    "#{post.title} #{url} via @#{Developer.twitter_handle(developer)} #til ##{channel.twitter_hashtag}"
    |> create_post()
  end

  def handle_post_liked(_post, _dev, _url) do
    :ok
  end

  def handle_page_views_report(_report) do
    :ok
  end

  def create_post(text) do
    Client.Credentials
    |> struct(credentials())
    |> Client.Session.create("https://bsky.social")
    |> Client.RecordManager.create_post(text: text)
  end

  defp credentials, do: Application.get_env(:tilex, __MODULE__)
end
