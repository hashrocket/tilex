defmodule TilexWeb.SharedView do
  use TilexWeb, :view

  def display_date(post) do
    post.inserted_at
    |> datetime_in_zone()
    |> Timex.format!("%B %-e, %Y", :strftime)
  end

  def rss_date(post) do
    post.inserted_at
    |> datetime_in_zone()
    |> Timex.format!("%a, %d %b %Y %H:%M:%S GMT", :strftime)
  end

  defp datetime_in_zone(datetime) do
    timezone = Timex.Timezone.get("America/Chicago", datetime)
    Timex.Timezone.convert(datetime, timezone)
  end

  def pluralize(1, object), do: "1 #{object}"
  def pluralize(count, object), do: "#{count} #{object}s"

  def pagination_href(conn, page) do
    conn.request_path <> "?" <> URI.encode_query(Map.put(conn.params, "page", page))
  end
end
