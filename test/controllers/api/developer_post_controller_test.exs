defmodule Tilex.Api.DeveloperPostControllerTest do
  use TilexWeb.ConnCase

  alias Tilex.Factory

  describe ".index" do
    def jack_post_titles do
      [
        "30 Rock Is Awesome",
        "I'm a Big Meanie",
        "Get It Together, Lemon",
        "Hello, Fellow Kids"
      ]
    end

    setup do
      jackdonaughy = Factory.insert!(:developer, username: "jackdonaughy")

      Enum.each(jack_post_titles(), fn title ->
        Factory.insert!(:post, title: title, developer: jackdonaughy)
      end)

      lizlemon = Factory.insert!(:developer, username: "lizlemon")
      Factory.insert!(:post, title: "Eye-rolling Is My Life", developer: lizlemon)
      :ok
    end

    test "returns all developer's posts sorted by date desc", %{conn: conn} do
      conn = get(conn, developer_post_path(conn, :index, username: "jackdonaughy"))

      post_titles =
        json_response(conn, 200)["data"]["posts"]
        |> Enum.reverse()
        |> Enum.map(& &1["title"])

      assert post_titles == jack_post_titles()
    end

    test "returns developer's posts limited by a certain amount", %{conn: conn} do
      conn = get(conn, developer_post_path(conn, :index, username: "jackdonaughy", limit: 3))

      post_titles =
        json_response(conn, 200)["data"]["posts"]
        |> Enum.reverse()
        |> Enum.map(& &1["title"])

      three_posts = jack_post_titles() |> Enum.take(-3)
      assert post_titles == three_posts
    end
  end
end
