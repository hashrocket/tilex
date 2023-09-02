defmodule Tilex.CreatePostWebhook do
  alias Tilex.Blog.Developer

  def call(post, developer, channel, url) do
    if webhook_url() do
      body = %{
        til: %{
          title: post.title,
          developer_name: Developer.twitter_handle(developer),
          channel: channel.twitter_hashtag,
          post_url: url
        }
      }

      Tesla.post(webhook_url(), Jason.encode!(body),
        headers: [{"content-type", "application/json"}]
      )
      |> case do
        {:ok, %Tesla.Env{status: 200}} -> :ok
        env -> {:error, env}
      end
    end
  end

  defp webhook_url, do: Application.get_env(:tilex, :webhook_url)
end
