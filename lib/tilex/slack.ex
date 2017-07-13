defmodule Tilex.Slack do

  def notify(post, developer, channel, url) do
    endpoint = System.get_env("slack_post_endpoint")
    text = prepare_text(post, developer, channel, url)

    spawn(
      fn ->
        HTTPoison.post("https://hooks.slack.com" <> endpoint, "{\"text\": \"#{text}\"}")
      end
    )
  end

  def prepare_text(post, developer, channel, url) do
    "#{developer.username} created a new post <#{url}|#{post.title}> ##{channel.name}"
  end
end
