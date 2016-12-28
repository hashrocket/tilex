defmodule Tilex.ChannelView do
  use Tilex.Web, :view

  def channel_header(posts, channel) do
    count = Enum.count(posts)
    noun  = if count == 1, do: "post", else: "posts"
    "#{count} #{noun} about ##{channel.name}"
  end
end
