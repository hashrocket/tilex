defmodule Tilex.PostControllerTest do
  use TilexWeb.ConnCase, async: true
  alias Tilex.Factory
  alias Tilex.Auth

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

  describe "when authenticated" do
    setup :authenticated_conn

    test "user can't set developer_id when creating posts", %{
      conn: conn,
      current_user: current_user,
      channel: channel
    } do
      other_user = Factory.insert!(:developer, username: "jackdonaughy")

      params = %{
        "post" => %{
          "developer_id" => other_user.id,
          "title" => "Not Jack's post",
          "body" => "Hello world",
          "channel_id" => channel.id
        }
      }

      post(conn, post_path(conn, :create, params))

      til =
        Tilex.Post
        |> Tilex.Repo.all()
        |> List.first()

      assert til.developer_id != other_user.id
      assert til.developer_id == current_user.id
    end

    test "user can't set likes when creating posts", %{
      conn: conn,
      channel: channel
    } do
      params = %{
        "post" => %{
          "likes" => 99_999,
          "title" => "Likeable post",
          "body" => "Hello world",
          "channel_id" => channel.id
        }
      }

      post(conn, post_path(conn, :create, params))

      til =
        Tilex.Post
        |> Tilex.Repo.all()
        |> List.first()

      assert til.likes == 1
    end

    test "user can't set max_likes when creating posts", %{
      conn: conn,
      channel: channel
    } do
      params = %{
        "post" => %{
          "max_likes" => 99_999,
          "title" => "Likeable post",
          "body" => "Hello world",
          "channel_id" => channel.id
        }
      }

      post(conn, post_path(conn, :create, params))

      til =
        Tilex.Post
        |> Tilex.Repo.all()
        |> List.first()

      assert til.max_likes == 1
    end

    test "user can't set developer_id when updating posts", %{
      conn: conn,
      current_user: current_user
    } do
      other_user = Factory.insert!(:developer, username: "jackdonaughy")

      til =
        Factory.insert!(:post,
          title: "Hi",
          body: "Body",
          likes: 1,
          max_likes: 1
        )

      params = %{
        post: %{
          title: "New Title",
          developer_id: other_user.id
        }
      }

      put(conn, post_path(conn, :update, til.slug, params))

      til =
        Tilex.Post
        |> Tilex.Repo.get(til.id)

      assert til.title == "New Title"
      assert til.developer_id != other_user.id
      assert til.developer_id == current_user.id
    end

    test "user can't set likes when updating posts", %{
      conn: conn
    } do
      til =
        Factory.insert!(:post,
          title: "Hi",
          body: "Body",
          likes: 1,
          max_likes: 1
        )

      params = %{
        post: %{
          title: "New Title",
          likes: 1_000_000
        }
      }

      put(conn, post_path(conn, :update, til.slug, params))

      til =
        Tilex.Post
        |> Tilex.Repo.get(til.id)

      assert til.title == "New Title"
      assert til.likes == 1
    end

    test "user can't set max_likes when updating posts", %{
      conn: conn
    } do
      til =
        Factory.insert!(:post,
          title: "Hi",
          body: "Body",
          likes: 1,
          max_likes: 1
        )

      params = %{
        post: %{
          title: "New Title",
          max_likes: 1_000_000
        }
      }

      put(conn, post_path(conn, :update, til.slug, params))

      til =
        Tilex.Post
        |> Tilex.Repo.get(til.id)

      assert til.title == "New Title"
      assert til.max_likes == 1
    end
  end

  defp authenticated_conn(%{conn: conn}) do
    current_user = Factory.insert!(:developer, email: "current@example.com", username: "current")
    channel = Factory.insert!(:channel, name: "git")

    conn = Auth.Guardian.Plug.sign_in(conn, current_user)
    {:ok, conn: conn, current_user: current_user, channel: channel}
  end
end
