defmodule Graphql.EndpointTest do
  use TilexWeb.ConnCase, async: true
  alias Tilex.Factory

  setup do
    jack = Factory.insert!(:developer, username: "jackdonaughy")

    jack_post_titles = [
      "30 Rock Is Awesome",
      "I'm a Big Meanie",
      "Get It Together, Lemon"
    ]

    Enum.each(jack_post_titles, fn title ->
      Factory.insert!(:post, title: title, developer: jack)
    end)

    lizlemon = Factory.insert!(:developer, username: "lizlemon")
    Factory.insert!(:post, title: "Eye-rolling Is My Life", developer: lizlemon)

    [jack_post_titles: jack_post_titles, liz_post_titles: ["Eye-rolling Is My Life"]]
  end

  describe "posts" do
    test "it returns first page of posts", %{
      jack_post_titles: jack_post_titles,
      liz_post_titles: liz_post_titles
    } do
      get_graphql_response(~s[{posts { title }}])
      |> assert_response_post_titles_match(jack_post_titles ++ liz_post_titles)
    end
  end

  describe "posts with developerUsername" do
    test "by default it returns a developer's 3 most recent posts", %{
      jack_post_titles: jack_post_titles
    } do
      get_graphql_response(~s[{posts(developerUsername:"jackdonaughy") { slug title }}])
      |> assert_response_post_titles_match(Enum.take(jack_post_titles, -3))
    end

    test "with limit 2 it returns a developer's 2 most recent posts", %{
      jack_post_titles: jack_post_titles
    } do
      get_graphql_response(~s[{posts(developerUsername:"jackdonaughy" limit:2) { slug title }}])
      |> assert_response_post_titles_match(Enum.take(jack_post_titles, -2))
    end
  end

  defp get_graphql_response(query) do
    get(
      build_conn(),
      "apiv2",
      query: query
    )
  end

  defp assert_response_post_titles_match(conn, titles) do
    json_response(conn, 200)["data"]["posts"]
    |> Enum.reverse()
    |> Enum.map(fn post -> post["title"] end)
    |> (fn posts ->
          assert posts == titles
        end).()
  end
end
