defmodule VisiorSearchesPosts do
  use Tilex.IntegrationCase

  def fill_in_search(session, query) do
    visit(session, "/")
    |> find(Query.css(".site_nav__search .site_nav__link"))
    |> Element.click()

    fill_in(session, Query.text_field("query"), with: query)
    |> take_screenshot
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
end
