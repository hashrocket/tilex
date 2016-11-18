defmodule TodayILearned.PostControllerTest do
  use TodayILearned.ConnCase

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert html_response(conn, 200) =~ "Today I Learned"
  end
end
