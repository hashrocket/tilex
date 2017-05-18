defmodule Tilex.Twitter do
  def notify(post, developer, channel, url) do
    text = "#{post.title} #{url} via @#{developer.twitter_handle} #til ##{channel.twitter_hashtag}"
    send_tweet(text)
  end

  def send_tweet(text) do
    spawn(
      fn ->
        ExTwitter.update(text)
      end
    )
  end
end
