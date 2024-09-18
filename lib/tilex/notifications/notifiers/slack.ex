defmodule Tilex.Notifications.Notifiers.Slack do
  use Tilex.Notifications.Notifier

  alias Tilex.Blog.Post

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
    :fire:
    :zap:
    :rocket:
    :saxophone:
    :mega:
    :crystal_ball:
    :beers:
    :revolving_hearts:
    :heart_eyes_cat:
    :scream_cat:
  )

  def handle_post_created(post, developer, channel, url, http \\ :httpc) do
    "#{developer.username} created a new post #{link(url, post.title)} in ##{channel.name}"
    |> send_slack_message(http)
  end

  def handle_post_liked(%Post{max_likes: max_likes, title: title}, developer, url, http \\ :httpc) do
    appropriate_emoji = Enum.at(@emoji, round(max_likes / 10 - 1), ":smile:")

    "#{developer.username}'s post has #{max_likes} likes! #{appropriate_emoji} - #{link(url, title)}"
    |> send_slack_message(http)
  end

  def handle_page_views_report(report, http \\ :httpc) do
    send_slack_message(report, http)
  end

  defp send_slack_message(message, http) do
    message = String.replace(message, "\"", "'")
    endpoint = slack_endpoint() |> String.to_charlist()
    request = {endpoint, [], ~c"application/json", "{\"text\": \"#{message}\"}"}
    http.request(:post, request, [], [])
  end

  defp link(url, text), do: "<#{url}|#{text}>"

  defp slack_endpoint, do: Application.get_env(:tilex, :slack_endpoint)
end
