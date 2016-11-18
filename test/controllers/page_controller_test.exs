defmodule TodayILearned.PageControllerTest do
  use TodayILearned.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Today I Learned"
  end
end
