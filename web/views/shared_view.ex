defmodule Tilex.SharedView do
  use Tilex.Web, :view

  def display_date(post) do
    Timex.format!(post.inserted_at, "%B %-e, %Y", :strftime)
  end

  def pluralize(1, object), do: "1 #{object}"
  def pluralize(count, object), do: "#{count} #{object}s"
end
