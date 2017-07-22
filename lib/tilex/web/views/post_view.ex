defmodule Tilex.Web.PostView do
  use Tilex.Web, :view

  def more_info?(channel) do
    File.exists?("lib/tilex/web/templates/shared/_#{channel.name}.html.eex")
  end
end
