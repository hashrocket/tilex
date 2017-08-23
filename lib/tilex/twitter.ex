defmodule Tilex.Twitter do
  alias Tilex.Developer

  def notify(post, developer, channel, url) do
    "#{post.title} #{url} via @#{Developer.twitter_handle(developer)} #til ##{channel.twitter_hashtag}"
    |> send_tweet
  end

  def send_tweet(text) do
    spawn(
      fn ->
        ExTwitter.update(text)
      end
    )
  end
end
