defmodule Tilex.Twitter do

  @moduledoc """
    Provides functions for posting to Twitter.
  """

  def notify(post, developer, channel, url) do
    "#{post.title} #{url} via @#{Tilex.Developer.twitter_handle(developer)} #til ##{channel.twitter_hashtag}"
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
