defmodule Tilex.DeveloperView do
  use Tilex.Web, :view

  alias Tilex.SharedView

  def developer_header(posts, developer) do
    count = Enum.count(posts)
    "#{SharedView.pluralize(count, "post")} by #{developer.username}"
  end
end
