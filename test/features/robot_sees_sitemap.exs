defmodule RobotSeesSitemap do
  use Tilex.IntegrationCase, async: false

  feature "And sees posts", %{session: session} do
    post = Factory.insert!(:post, title: "Klaus and Greta")

    visit(session, "/sitemap.xml")

    assert find(session, Query.css("loc", text: Tilex.Blog.Post.slugified_title(post.title)))
  end
end
