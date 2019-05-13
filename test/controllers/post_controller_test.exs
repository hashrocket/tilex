defmodule Tilex.PostControllerTest do
  use TilexWeb.ConnCase
  alias Tilex.Factory

  test "lists all entries on index", %{conn: conn} do
    conn = get(conn, post_path(conn, :index))
    assert html_response(conn, 200) =~ "Today I Learned"
  end

  test "supports a pagination parameter", %{conn: conn} do
    conn = get(conn, post_path(conn, :index, page: "1"))
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

  test "returns 200 and likes with permitted IP address", %{conn: conn} do
    Application.put_env(:tilex, :blocked_ips, "168.0.0.1")

    lizlemon = Factory.insert!(:developer, username: "lizlemon")
    post = Factory.insert!(:post, title: "Eye-rolling Is My Life", developer: lizlemon)
    post_likes = post.likes

    conn = post(conn, post_path(conn, :like, post.slug))

    assert json_response(conn, 200)

    new_post_likes = Tilex.Repo.get(Tilex.Post, post.id).likes
    assert post_likes + 1 == new_post_likes
  end

  test "returns no-op 200 with blocked IP address", %{conn: conn} do
    Application.put_env(:tilex, :blocked_ips, "127.0.0.1")

    lizlemon = Factory.insert!(:developer, username: "lizlemon")
    post = Factory.insert!(:post, title: "Eye-rolling Is My Life", developer: lizlemon)
    post_likes = post.likes

    conn = post(conn, post_path(conn, :like, post.slug))

    assert json_response(conn, 200)

    new_post_likes = Tilex.Repo.get(Tilex.Post, post.id).likes
    assert post_likes == new_post_likes
  end
end
