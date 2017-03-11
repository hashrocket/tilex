defmodule Tilex.PostView do
  use Tilex.Web, :view

  def more_info?(channel) do
    File.exists?("web/templates/shared/_#{channel.name}.html.eex")
  end

  def post_pluralization(1), do: "1 post"
  def post_pluralization(count), do: "#{count} posts"
end
