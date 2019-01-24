defmodule TilexWeb.SharedView do
  use TilexWeb, :view

  alias Guardian.Plug
  alias Timex.Timezone

  def display_date(post) do
    inserted_at =
      case Application.get_env(:tilex, :date_display_tz) do
        x when x in [nil, ""] ->
          post.inserted_at

        tz ->
          tz = Timezone.get(tz)
          Timezone.convert(post.inserted_at, tz)
      end

    Timex.format!(inserted_at, "%B %-e, %Y", :strftime)
  end

  def rss_date(post) do
    Timex.format!(post.inserted_at, "%a, %d %b %Y %H:%M:%S GMT", :strftime)
  end

  def pluralize(1, object), do: "1 #{object}"
  def pluralize(count, object), do: "#{count} #{object}s"

  def pagination_href(conn, page) do
    conn.request_path <> "?" <> URI.encode_query(Map.put(conn.params, "page", page))
  end

  def post_creator_or_admin?(conn, post) do
    Plug.current_resource(conn) &&
      (post.developer == Plug.current_resource(conn) || Plug.current_resource(conn).admin)
  end
end
