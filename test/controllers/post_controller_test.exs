defmodule Tilex.PostControllerTest do
  use TilexWeb.ConnCase

  test "lists all entries on index", %{conn: conn} do
    conn = get(conn, post_path(conn, :index))
    assert html_response(conn, 200) =~ "Today I Learned"
  end

  test "redirects to root when non-developer visits posts/new path", %{conn: conn} do
    conn = get(conn, post_path(conn, :new))
    assert html_response(conn, 302)
  end

  test "throws 404 with slug less than 10 characters", %{conn: conn} do
    conn = get(conn, post_path(conn, :edit, "123456789"))
    assert html_response(conn, 404)
  end
end
