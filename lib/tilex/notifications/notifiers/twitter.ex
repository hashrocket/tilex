defmodule Tilex.Notifications.Notifiers.Twitter do
  alias OAuther
  alias Tilex.Blog.Developer

  use Tilex.Notifications.Notifier

  def handle_post_created(post, developer, channel, url) do
    "#{post.title} #{url} via @#{Developer.twitter_handle(developer)} #til ##{channel.twitter_hashtag}"
    |> send_tweet
  end

  def handle_post_liked(_post, _dev, _url) do
    :ok
  end

  def handle_page_views_report(_report) do
    :ok
  end

  @tweets_url "https://api.x.com/2/tweets"

  def send_tweet(message) do
    params = %{
      "text" => message
    }

    headers =
      oauth_headers("post", @tweets_url)

    Req.post!(@tweets_url, headers: headers, json: params)
  end

  defp oauth_headers(method, url) do
    {auth_header, _params} =
      OAuther.sign(method, url, [], oauth_creds())
      |> OAuther.header()

    [auth_header]
  end

  def oauth_creds do
    consumer_key = System.get_env("twitter_consumer_key")
    consumer_secret = System.get_env("twitter_consumer_secret")
    access_token = System.get_env("twitter_access_token")
    access_token_secret = System.get_env("twitter_access_token_secret")

    OAuther.credentials(
      method: :hmac_sha1,
      consumer_key: consumer_key,
      consumer_secret: consumer_secret,
      token: access_token,
      token_secret: access_token_secret
    )
  end
end
