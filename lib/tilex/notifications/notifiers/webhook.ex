defmodule Tilex.Notifications.Notifiers.Webhook do
  use Tilex.Notifications.Notifier

  alias Tilex.CreatePostWebhook

  def handle_post_created(post, developer, channel, url) do
    CreatPostWebhook.call(post, developer, channel, url)
  end

  def handle_post_liked(_post, _dev, _url) do
    :ok
  end

  def handle_page_views_report(_report) do
    :ok
  end
end
