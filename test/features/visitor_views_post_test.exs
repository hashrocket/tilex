defmodule VisitorViewsPostTest do
  use Tilex.IntegrationCase, async: true

  test "the page shows a post", %{session: session} do

    developer = Factory.insert!(:developer, username: "makinpancakes")
    post = Factory.insert!(:post, title: "A special post", developer: developer)

    body = visit(session, post_path(Endpoint, :show, post))
      |> find(Query.css("body"))
      |> Element.text

    assert body =~ ~r/A special post/
    assert body =~ ~r/makinpancakes/
  end

  test "and sees marketing copy, if it exists", %{session: session} do

    marketing_channel = Factory.insert!(:channel, name: "elixir")
    post_in_marketing_channel = Factory.insert!(:post, channel: marketing_channel)

    copy = visit(session, post_path(Endpoint, :show, post_in_marketing_channel))
           |> find(Query.css(".more-info"))
           |> Element.text

    {:ok, marketing_content} = File.read("web/templates/shared/_elixir.html.eex")
    assert copy =~ String.slice(marketing_content, 0, 10)
  end

  test "and sees a special slug", %{session: session} do

    post = Factory.insert!(:post, title: "Super Sluggable Title")
    url = visit(session, post_path(Endpoint, :show, post))
      |> current_url

    assert url =~ "#{post.slug}-super-sluggable-title"

    changeset = Post.changeset(post, %{title: "Alternate Also Cool Title"})
    Repo.update!(changeset)
    post = Repo.get(Post, post.id)
    url = visit(session, post_path(Endpoint, :show, post))
      |> current_url

    assert url =~ "#{post.slug}-alternate-also-cool-title"
  end

  test "and clicks 'like' for that post", %{session: session} do

    developer = Factory.insert!(:developer, username: "makinpancakes")
    post = Factory.insert!(:post, title: "A special post", developer: developer, likes: 1)

    link = visit(session, post_path(Endpoint, :show, post))
      |> find(Query.css(".post .js-like-action"))

    click(link)

    find(session, Query.css(".post .js-like-action.liked"))

    post = Repo.get(Post, post.id)
    assert post.likes == 2
    assert post.max_likes == 2
  end
end
