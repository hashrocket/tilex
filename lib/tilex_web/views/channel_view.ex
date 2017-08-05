defmodule TilexWeb.ChannelView do
  use TilexWeb, :view

  alias TilexWeb.SharedView

  def channel_header(posts_count, channel) do
    "#{SharedView.pluralize(posts_count, "post")} about ##{channel.name}"
  end
end
