defmodule Tilex.Notifications.Notifiers.Twitter do
  alias Tilex.Developer

  use Tilex.Notifications.Notifier

  def handle_post_created(post, developer, channel, url) do
    "#{post.title} #{url} via @#{Developer.twitter_handle(developer)} #til ##{channel.twitter_hashtag}"
    |> send_tweet
  end

  def handle_post_liked(_post, _dev, _url) do
    :ok
  end

  def send_tweet(text) do
    ExTwitter.update(text)
  end
end
