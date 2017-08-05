defmodule TilexWeb.PostView do
  use TilexWeb, :view

  def more_info?(channel) do
    File.exists?("lib/tilex_web/templates/shared/_#{channel.name}.html.eex")
  end
end
