defmodule Tilex.Notifications.Notifiers.SlackTest do
  use ExUnit.Case, async: true

  alias Tilex.Notifications.Notifiers.Slack
  alias Tilex.Blog.Channel
  alias Tilex.Blog.Developer
  alias Tilex.Blog.Post

  defmodule HTTPMock do
    def request(
          :post,
          {~c"https://slack.test.com/abc/123", [], ~c"application/json", payload},
          [],
          []
        ) do
      {:ok, payload}
    end
  end

  describe "handle_post_created/5" do
    test "notifies post creation for simple post" do
      post = %Post{title: "simple post"}
      developer = %Developer{username: "vnegrisolo"}
      channel = %Channel{name: "ruby"}
      url = "http://til.test.com/abc123"
      message = "vnegrisolo created a new post <http://til.test.com/abc123|simple post> in #ruby"

      assert Slack.handle_post_created(post, developer, channel, url, HTTPMock) ==
               {:ok, "{\"text\": \"#{message}\"}"}
    end

    test "notifies post creation for post with double quotes" do
      post = %Post{title: "post with \"double\" quote"}
      developer = %Developer{username: "vnegrisolo"}
      channel = %Channel{name: "ruby"}
      url = "http://til.test.com/abc123"

      message =
        "vnegrisolo created a new post <http://til.test.com/abc123|post with 'double' quote> in #ruby"

      assert Slack.handle_post_created(post, developer, channel, url, HTTPMock) ==
               {:ok, "{\"text\": \"#{message}\"}"}
    end
  end

  describe "handle_post_liked/4" do
    test "notifies post liked for simple post" do
      post = %Post{title: "simple post", max_likes: 20}
      developer = %Developer{username: "vnegrisolo"}
      url = "http://til.test.com/abc123"

      message =
        "vnegrisolo's post has 20 likes! :birthday: - <http://til.test.com/abc123|simple post>"

      assert Slack.handle_post_liked(post, developer, url, HTTPMock) ==
               {:ok, "{\"text\": \"#{message}\"}"}
    end

    test "notifies post liked for post with double quotes" do
      post = %Post{title: "post with \"double\" quote", max_likes: 20}
      developer = %Developer{username: "vnegrisolo"}
      url = "http://til.test.com/abc123"

      message =
        "vnegrisolo's post has 20 likes! :birthday: - <http://til.test.com/abc123|post with 'double' quote>"

      assert Slack.handle_post_liked(post, developer, url, HTTPMock) ==
               {:ok, "{\"text\": \"#{message}\"}"}
    end
  end

  describe "handle_page_views_report/2" do
    test "notifies page views report" do
      report = """
      Best Day Last Week:   10
      Last Week:            20
      Best Day Week Before: 30
      Week Before:          40
      """

      assert Slack.handle_page_views_report(report, HTTPMock) ==
               {:ok, "{\"text\": \"#{report}\"}"}
    end
  end
end
