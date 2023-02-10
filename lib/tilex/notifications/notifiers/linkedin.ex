defmodule Tilex.Notifications.Notifiers.Linkedin do
  alias Tilex.Blog.Developer

  import Tilex.LinkedinApi

  use Tilex.Notifications.Notifier

  @impl true
  def handle_post_created(post, developer, channel, url) do
    "#{post.title} by #{Developer.name(developer)} #til ##{channel.twitter_hashtag}"
    |> create_post(post.title, url)
  end

  @impl true
  def handle_post_liked(_post, _dev, _url) do
    :ok
  end

  @impl true
  def handle_page_views_report(_report) do
    :ok
  end
end
