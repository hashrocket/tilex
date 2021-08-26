defmodule Tilex.Api.PostControllerTest do
  use TilexWeb.ConnCase, async: true

  alias Tilex.Factory

  test "returns the entries", %{conn: conn} do
    lizlemon = Factory.insert!(:developer, username: "lizlemon")
    Factory.insert!(:post,
      title: "Eye-rolling Is My Life",
      developer: lizlemon,
      inserted_at: Timex.to_datetime({{2018, 1, 1}, {1, 1, 0}}, "Etc/UTC")
    )

    jackdonaughy = Factory.insert!(:developer, username: "jackdonaughy")

    jack_post_titles = [
      "30 Rock Is Awesome",
      "I'm a Big Meanie",
      "Get It Together, Lemon"
    ]

    jack_post_titles
    |> Enum.with_index()
    |> Enum.map(fn {title, index} ->
      Factory.insert!(:post,
        title: title,
        developer: jackdonaughy,
        inserted_at: Timex.to_datetime({{2018, 1, 1}, {1, 2, index}}, "Etc/UTC")
      )
    end)

    conn = get(conn, api_post_path(conn, :index))

    expected_post_titles = ["Eye-rolling Is My Life"] ++ jack_post_titles

    json_response(conn, 200)["data"]["posts"]
    |> Enum.reverse()
    |> Enum.map(fn post -> post["title"] end)
    |> (fn posts ->
          assert length(posts) === 4
          assert posts == expected_post_titles
        end).()
  end
end
