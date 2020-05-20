defmodule Tilex.Notifications.Notifiers.Slack do
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

  use Tilex.Notifications.Notifier

  def handle_post_created(post, developer, channel, url) do
    "#{developer.username} created a new post <#{url}|#{post.title}> ##{channel.name}"
    |> send_slack_message
  end

  def handle_post_liked(%Tilex.Post{max_likes: max_likes, title: title}, developer, url) do
    appropriate_emoji =
      @emoji
      |> Enum.at(round(max_likes / 10 - 1), ":smile:")

    "#{developer.username}'s post has #{max_likes} likes! #{appropriate_emoji} - <#{url}|#{title}>"
    |> send_slack_message
  end

  def handle_page_views_report(report) do
    report
    |> send_slack_message
  end

  defp send_slack_message(message) do
    endpoint =
      String.to_charlist("https://hooks.slack.com" <> System.get_env("slack_post_endpoint"))

    :httpc.request(
      :post,
      {endpoint, [], 'application/json', "{\"text\": \"#{message}\"}"},
      [],
      []
    )
  end
end
