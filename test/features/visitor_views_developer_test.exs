defmodule Features.VisitorViewsDeveloper do
  use Tilex.IntegrationCase, async: Application.get_env(:tilex, :async_feature_test)

  alias TilexWeb.Endpoint

  test "and sees the developer's posts", %{session: session} do
    developer = Factory.insert!(:developer, username: "makinpancakes")
    post = Factory.insert!(:post, developer: developer)

    session
    |> visit(post_path(Endpoint, :show, post))
    |> find(Query.css("body"))

    visit(session, developer_path(Endpoint, :show, developer))
    page_header = Element.text(find(session, Query.css(".page_head")))

    assert page_header =~ ~r/1 post by makinpancakes/
    assert find(session, Query.css("article.post"))
    assert page_title(session) == "makinpancakes - Today I Learned"
  end

  test "and sees a prolific developer's posts", %{session: session} do
    developer = Factory.insert!(:developer, username: "banjocardhush")

    Factory.insert_list!(:post, 7, developer: developer)

    visit(session, developer_path(Endpoint, :show, developer))

    page_header = Element.text(find(session, Query.css(".page_head")))
    assert page_header =~ ~r/7 posts by banjocardhush/
  end

  test "and sees the developer's twitter when set", %{session: session} do
    developer = Factory.insert!(:developer, twitter_handle: "makinbaconpancakes")

    visit(session, developer_path(Endpoint, :show, developer))

    assert has?(session, Query.link("@makinbaconpancakes"))
  end
end
