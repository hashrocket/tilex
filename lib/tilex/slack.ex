defmodule Tilex.Slack do
  def notify(post, developer, channel, url) do
    "#{developer.username} created a new post <#{url}|#{post.title}> ##{channel.name}"
    |> send_slack_message
  end

  def notify_of_awards(%Tilex.Post{max_likes: max_likes, title: title}, developer, url) do
    appropriate_emoji = [ "🎉", "🎂", "✨", "💥", "❤️", "🎈", "👑", "🎓", "🏆", "💯 "]
                        |> Enum.at(round((max_likes / 10) - 1), "😀")

    "#{developer.username}'s post has #{max_likes} likes! #{appropriate_emoji} - <#{url}|#{title}>"
    |> send_slack_message
  end

  defp send_slack_message(message) do
    endpoint = System.get_env("slack_post_endpoint")

    spawn(
      fn ->
        HTTPoison.post("https://hooks.slack.com" <> endpoint, "{\"text\": \"#{message}\"}")
      end
    )
  end
end
