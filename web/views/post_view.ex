defmodule Tilex.PostView do
  use Tilex.Web, :view

  def more_info?(channel) do
    File.exists?("web/templates/shared/_#{channel.name}.html.eex")
  end
end
