defmodule Tilex.PostControllerTest do
  use TilexWeb.ConnCase

  test "lists all entries on index", %{conn: conn} do
    conn = get(conn, post_path(conn, :index))
    assert html_response(conn, 200) =~ "Today I Learned"
  end

  test "supports a pagination parameter", %{conn: conn} do
    conn = get(conn, post_path(conn, :index, page: 1))
    assert html_response(conn, 200) =~ "Today I Learned"
  end

  test "supports a bad pagination parameter", %{conn: conn} do
    conn = get(conn, post_path(conn, :index, page: "a"))
    assert html_response(conn, 200) =~ "Today I Learned"
  end

  test "supports a bad pagination parameter while searching", %{conn: conn} do
    conn = get(conn, post_path(conn, :index, page: "a", q: "Hot posts"))
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
