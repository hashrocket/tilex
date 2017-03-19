defmodule Tilex.ChannelView do
  use Tilex.Web, :view

  alias Tilex.SharedView

  def channel_header(posts, channel) do
    count = Enum.count(posts)
    "#{SharedView.pluralize(count, "post")} about ##{channel.name}"
  end
end
