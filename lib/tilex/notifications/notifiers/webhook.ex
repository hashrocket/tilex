defmodule Tilex.Notifications.Notifiers.Webhook do
  alias Tilex.Blog.Developer

  use Tilex.Notifications.Notifier

  def handle_post_created(post, developer, channel, url) do
    if webhook_url() do
      payload = %{
        til: %{
          title: post.title,
          developer_name: Developer.twitter_handle(developer),
          channel: channel.twitter_hashtag,
          post_url: url
        }
      }

      Req.post(webhook_url(), json: payload)
    end
  end

  def handle_post_liked(_post, _dev, _url) do
    :ok
  end

  def handle_page_views_report(_report) do
    :ok
  end

  defp webhook_url, do: Application.get_env(:tilex, :webhook_url)
end
