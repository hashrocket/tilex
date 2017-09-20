defmodule Test.Notifications.Notifiers.Slack do
  use Tilex.Notifications.Notifier

  def handle_post_created(_post, _developer, _channel, _url) do
    :ok
  end

  def handle_post_liked(_post, _developer, _url) do
    :ok
  end
end
