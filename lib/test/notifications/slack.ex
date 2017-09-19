defmodule Test.Notifications.Slack do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def post_created(_post, _developer, _channel, _url) do
    :ok
  end

  def post_liked(_post, _developer, _url) do
    :ok
  end
end
