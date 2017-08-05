defmodule TilexWeb.DeveloperView do
  use TilexWeb, :view

  alias TilexWeb.SharedView

  def developer_header(posts_count, developer) do
    "#{SharedView.pluralize(posts_count, "post")} by #{developer.username}"
  end
end
