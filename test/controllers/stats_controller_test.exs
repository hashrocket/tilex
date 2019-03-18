defmodule Tilex.StatsControllerTest do
  use TilexWeb.ConnCase, async: true

  test 'developer/2 redirects to stats index when unauthenticated', %{conn: conn} do
    response = get(conn, stats_path(conn, :developer))
    assert html_response(response, 302)
  end
end
