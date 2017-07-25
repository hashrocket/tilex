defmodule Test.Slack do
  def notify(_post, _developer, _channel, _url) do
    :ok
  end

  def notify_of_awards(_post, _developer, _url) do
    :ok
  end
end
