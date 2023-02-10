defmodule Tilex.LinkedinApi do
  use Tesla, only: [:post]

  @middleware [
    {Tesla.Middleware.BaseUrl, "https://api.linkedin.com/v2"},
    Tesla.Middleware.JSON
  ]

  def create_post(commentary, title, url) do
    body = %{
      author: "urn:li:organization:" <> org_id(),
      commentary: commentary,
      visibility: "PUBLIC",
      distribution: %{
        feedDistribution: "MAIN_FEED",
        targetEntities: [],
        thirdPartyDistributionChannels: []
      },
      content: %{
        article: %{
          source: url,
          title: title
        }
      },
      lifecycleState: "PUBLISHED",
      isReshareDisabledByAuthor: false
    }

    client()
    |> post("/posts", body)
    |> case do
      {:ok, %Tesla.Env{status: 200}} -> :ok
      env -> {:error, env}
    end
  end

  defp client() do
    middleware =
      [
        {Tesla.Middleware.BearerAuth, token: access_token()}
      ] ++ @middleware

    Tesla.client(middleware)
  end

  defp config, do: Application.get_env(:tilex, __MODULE__)
  defp org_id, do: Keyword.fetch!(config(), :organization_id)
  defp access_token, do: Keyword.fetch!(config(), :access_token)
end
