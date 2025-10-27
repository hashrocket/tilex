defmodule Tilex.Notifications.Notifiers.Webhook do
  use Tilex.Notifications.Notifier

  def handle_post_created(post, developer, channel, url) do
    if webhook_configured?() do
      payload = %{
        event: "post.created",
        til: %{
          title: post.title,
          author_name: developer.username,
          channel: channel.twitter_hashtag,
          post_url: url
        }
      }

      Req.post(webhook_url(), json: payload, auth: {:basic, webhook_basic_auth()})
    end
  end

  def handle_post_liked(_post, _dev, _url) do
    :ok
  end

  def handle_page_views_report(_report) do
    :ok
  end

  defp webhook_configured?, do: !!webhook_url() && !!webhook_basic_auth()

  defp webhook_url, do: Application.get_env(:tilex, :webhook_url)

  defp webhook_basic_auth, do: Application.get_env(:tilex, :webhook_basic_auth)
end
