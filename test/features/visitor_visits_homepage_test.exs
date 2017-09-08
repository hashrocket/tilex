defmodule VisitorVisitsHomepageTest do
  use Tilex.IntegrationCase, async: Application.get_env(:tilex, :async_feature_test)

  test "the page does not have a Create Post link", %{session: session} do
    visit(session, "/")

    refute has?(session, Query.link("Create Post"))
  end

  test "the page has the appropriate branding", %{session: session} do
    header_text = session
                  |> visit("/")
                  |> find(Query.css("h1 > a"))
                  |> Element.text

    assert header_text =~ ~r/Today I Learned/i
  end

  test "the page has a list of posts", %{session: session} do
    channel = Factory.insert!(:channel, name: "smalltalk")

    Factory.insert!(:post,
      title: "A post about porting Rails applications to Phoenix",
      body: "It starts with Rails and ends with Elixir",
      channel: channel
    )

    visit(session, "/")

    element_text = fn (session, selector) ->
      Element.text(find(session, Query.css(selector)))
    end

    post_header = element_text.(session, "article h1")
    post_body   = element_text.(session, "article")
    post_footer = element_text.(session, ".post aside")

    assert post_header == "A post about porting Rails applications to Phoenix"
    assert post_body   =~ ~r/It starts with Rails and ends with Elixir/
    assert post_footer =~ ~r/#smalltalk/i
  end

  test "the page has a list of paginated posts", %{session: session} do
    Factory.insert_list!(:post, 5 + 1)

    visit(session, "/")

    assert find(session, Query.css("article.post", count: 5))
    assert find(session, Query.css("nav.pagination", visible: true))

    visit(session, "/?page=2")

    assert find(session, Query.css("article.post", count: 1))

    visit(session, "/")

    assert find(session, Query.css("article.post", count: 5))
  end
end
