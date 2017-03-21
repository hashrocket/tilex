defmodule Tilex.DeveloperView do
  use Tilex.Web, :view

  alias Tilex.SharedView

  def developer_header(posts_count, developer) do
    "#{SharedView.pluralize(posts_count, "post")} by #{developer.username}"
  end
end
