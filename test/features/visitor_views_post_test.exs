defmodule VisitorViewsPostTest do
  use Tilex.IntegrationCase, async: Application.get_env(:tilex, :async_feature_test)

  alias TilexWeb.Endpoint

  alias Tilex.Integration.Pages.{
    PostShowPage
  }

  test "the page shows a post", %{session: session} do
    developer = Factory.insert!(:developer)
    channel = Factory.insert!(:channel, name: "command-line")
    post = Factory.insert!(:post,
      title: "A special post",
      body: "This is how to be super awesome!",
      developer: developer,
      channel: channel
    )

    session
    |> PostShowPage.navigate(post)
    |> PostShowPage.expect_post_attributes(%{
      title: "A special post",
      body: "This is how to be super awesome!",
      channel: "#command-line",
      likes_count: 1
    })

    assert page_title(session) == "A special post - Today I Learned"
  end

  test "and sees marketing copy, if it exists", %{session: session} do
    marketing_channel = Factory.insert!(:channel, name: "elixir")
    post_in_marketing_channel = Factory.insert!(:post, channel: marketing_channel)

    copy = session
           |> visit(post_path(Endpoint, :show, post_in_marketing_channel))
           |> find(Query.css(".more-info"))
           |> Element.text

    {:ok, marketing_content} = File.read("lib/tilex_web/templates/shared/_elixir.html.eex")
    assert copy =~ String.slice(marketing_content, 0, 10)
  end

  test "and sees a special slug", %{session: session} do
    post = Factory.insert!(:post, title: "Super Sluggable Title")
    url = session
          |> visit(post_path(Endpoint, :show, post))
          |> current_url

    assert url =~ "#{post.slug}-super-sluggable-title"

    changeset = Post.changeset(post, %{title: "Alternate Also Cool Title"})
    Repo.update!(changeset)
    post = Repo.get(Post, post.id)
    url = session
          |> visit(post_path(Endpoint, :show, post))
          |> current_url

    assert url =~ "#{post.slug}-alternate-also-cool-title"
  end

  test "and sees a channel specific twitter card and a post specific twitter description", %{session: session} do
    popular_channel = Factory.insert!(:channel, name: "command-line")
    post = Factory.insert!(:post, channel: popular_channel, body: "One sentence that sets up the post.\nAnother sentence that is more informative")

    image_url = session
           |> visit(post_path(Endpoint, :show, post))
           |> find(Query.css("meta[name='twitter:image']", visible: false))
           |> Element.attr("content")

    assert image_url =~ "command_line_twitter_card.png"

    twitter_description = session
           |> find(Query.css("meta[name='twitter:description']", visible: false))
           |> Element.attr("content")

    assert twitter_description =~ "One sentence that sets up the post."
    refute twitter_description =~ "Another sentence"
  end

  test "and clicks 'like' for that post", %{session: session} do
    developer = Factory.insert!(:developer)
    post = Factory.insert!(:post, title: "A special post", developer: developer, likes: 1)

    session
    |> visit(post_path(Endpoint, :show, post))
    |> find(Query.css("header[data-likes-loaded=true]"))

    link = find(session, Query.css(".post .js-like-action"))

    Element.click(link)

    session
    |> assert_has(Query.css("header[data-likes-loaded=true]"))
    |> assert_has(Query.css(".post .js-like-action.liked"))

    post = Repo.get(Post, post.id)
    assert post.likes == 2
    assert post.max_likes == 2

    Element.click(link)

    session
    |> assert_has(Query.css("header[data-likes-loaded=true]"))
    |> assert_has(Query.css(".post .js-like-action"))
    |> refute_has(Query.css(".post .js-like-action.liked"))

    post = Repo.get(Post, post.id)
    assert post.likes == 1
    assert post.max_likes == 2
  end

  test "sees raw markdown version", %{session: session} do
    title = "A special post"
    body = """
    # title
    **some text**
    [hashrocket](http://hashrocket.com)
    """
    developer = Factory.insert!(:developer)
    post = Factory.insert!(:post,
                           title: title,
                           body: body,
                           developer: developer)

    session
    |> visit("#{post_path(Endpoint, :show, post)}.md")

    assert text(session) == String.trim("""
    #{title}

    #{body}

    #{developer.username}
    #{TilexWeb.SharedView.display_date(post)}
    """)
  end

  test "via the random url", %{session: session} do
    post = Factory.insert!(:post)

    session
    |> visit(post_path(Endpoint, :random))
    |> PostShowPage.expect_post_attributes(%{
      title: post.title,
      body: post.body,
      channel: post.channel.name,
      likes_count: 1
    })

    assert page_title(session) == "#{post.title} - Today I Learned"
  end
end
