defmodule Tilex.Slack do
  def notify(post, developer, channel, url) do
    endpoint = System.get_env("slack_post_endpoint")
    text = "#{developer.username} created a new post <#{url}|#{post.title}> ##{channel.twitter_hashtag}"

    spawn(
      fn ->
        HTTPoison.post("https://hooks.slack.com" <> endpoint, "{\"text\": \"#{text}\"}")
      end
    )
  end
end
