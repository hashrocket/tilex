defmodule VisiorSearchesPosts do
  use Tilex.IntegrationCase, async: Application.get_env(:tilex, :async_feature_test)

  def fill_in_search(session, query) do
    session
    |> visit("/")
    |> find(Query.css(".site_nav__search .site_nav__link"))
    |> Element.click()

    session
    |> fill_in(Query.text_field("q"), with: query)
    |> click(Query.button("Search"))
  end

  test "with no found posts", %{session: session} do
    Factory.insert!(:post,
      title: "elixir is awesome"
    )
    fill_in_search(session, "ruby on rails")
    search_result_header = get_text(session, "#search")

    assert search_result_header == "0 posts about ruby on rails"
  end

  test "with 2 found posts", %{session: session} do
    ["Elixir Rules", "Because JavaScript", "Hashrocket Rules"]
    |> Enum.each(&(Factory.insert!(:post, title: &1)))

    fill_in_search(session, "rules")

    search_result_header = get_text(session, "#search")
    body = get_text(session, "body")

    assert search_result_header == "2 posts about rules"
    assert find(session, Query.css("article.post", [count: 2]))
    assert body =~ ~r/Elixir Rules/
    assert body =~ ~r/Hashrocket Rules/
    refute body =~ ~r/Because JavaScript/
  end

  test "with paginated query results", %{session: session} do
    max_posts_on_page = Application.get_env(:tilex, :page_size)

    1..(max_posts_on_page * 2)
    |> Enum.map(&("Random Elixir Post #{&1}"))
    |> Enum.each(&(Factory.insert!(:post, title: &1)))

    Factory.insert!(:post, title: "No Match")

    fill_in_search(session, "Elixir")

    first_page_first_post = get_first_post_on_page_title(session)
    search_result_header = get_text(session, "#search")

    assert search_result_header == "10 posts about Elixir"
    assert find(session, Query.css("article.post", [count: max_posts_on_page]))

    visit(session, "/?_utf8=✓&page=2&q=Elixir")

    second_page_first_post = get_first_post_on_page_title(session)
    search_result_header = get_text(session, "#search")

    assert search_result_header == "10 posts about Elixir"
    refute first_page_first_post == second_page_first_post
    assert find(session, Query.css("article.post", [count: max_posts_on_page]))
  end

  defp get_first_post_on_page_title(session) do
    get_text(session, "#home > section:first-child article.post h1 a")
  end
end
