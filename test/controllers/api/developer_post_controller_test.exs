defmodule Tilex.Api.DeveloperPostControllerTest do
  use TilexWeb.ConnCase

  alias Tilex.Factory

  test "returns a developer's most recent posts", %{conn: conn} do
    jackdonaughy = Factory.insert!(:developer, username: "jackdonaughy")
    jack_post_titles = [
      "30 Rock Is Awesome",
      "I'm a Big Meanie",
      "Get It Together, Lemon",
    ]

    Enum.each(jack_post_titles, fn(title) ->
      Factory.insert!(:post, title: title, developer: jackdonaughy)
    end)

    lizlemon = Factory.insert!(:developer, username: "lizlemon")
    Factory.insert!(:post, title: "Eye-rolling Is My Life", developer: lizlemon)

    conn = get conn, developer_post_path(conn, :index, username: "jackdonaughy")

    json_response(conn, 200)["data"]["posts"]
    |> Enum.reverse
    |> Enum.map(fn (post) -> post["title"] end)
    |> (fn(posts) ->
      assert posts == jack_post_titles
    end).()
  end
end
