defmodule TilexWeb.ChannelView do
  use TilexWeb, :view

  alias TilexWeb.SharedView

  def channel_header(posts_count, channel, random) do
    " #{if random, do: "Random post", else: SharedView.pluralize(posts_count, "post")} about ##{channel.name}"
  end
end
