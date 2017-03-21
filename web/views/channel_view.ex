defmodule Tilex.ChannelView do
  use Tilex.Web, :view

  alias Tilex.SharedView

  def channel_header(posts_count, channel) do
    "#{SharedView.pluralize(posts_count, "post")} about ##{channel.name}"
  end
end
