defmodule Test.Notifications.Notifiers.Twitter do
  use Tilex.Notifications.Notifier

  def handle_post_created(_post, _developer, _channel, _url) do
    :ok
  end

  def handle_post_liked(_post, _developer, _url) do
    :ok
  end

  def handle_page_views_report(_pid) do
    :ok
  end
end
