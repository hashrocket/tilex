defmodule Tilex.Api.PostControllerTest do
  use TilexWeb.ConnCase, async: true

  alias Tilex.Factory

  test "returns the last 10 posts", %{conn: conn} do
    rick = Factory.insert!(:developer, username: "rickC137")

    rick_post_titles = [
      "Existence is Pain",
      "Morty Replication",
      "Doing it your way, aka the Dumb Way",
      "Evil Morty Blueprint",
      "Summer's iPhone Backup",
      "Jerry Mind Control",
      "Obtaining Space Car Insurance",
      "Interdimensional How To",
      "Effective Use of the Portal Gun",
      "Universe Backup"
    ]

    rick_post_titles
    |> Enum.with_index()
    |> Enum.map(fn {title, index} ->
      Factory.insert!(:post,
        title: title,
        developer: rick,
        inserted_at: Timex.to_datetime({{2018, 1, 1}, {1, 1, index}}, "Etc/UTC")
      )
    end)

    conn = get(conn, post_path(conn, :index))

    json_response(conn, 200)["data"]["posts"]
    |> Enum.map(fn post -> post["title"] end)
    |> (fn posts ->
          assert posts == rick_post_titles
        end).()
  end
end
