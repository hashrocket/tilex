defmodule Tilex.LinkedinApi do
  use Tesla, only: [:post]

  plug Tesla.Middleware.BaseUrl, "https://api.linkedin.com/v2"
  plug Tesla.Middleware.Headers, [{"Content-Type", "application/json"}]
  plug Tesla.Middleware.BearerAuth, token: Application.get_env(:tilex, :linkedin_access_token)
  plug Tesla.Middleware.JSON

  def create_post(post_body) do
    post("/posts", post_body)
  end

  def create_post_body(commentary, title, url) do
    %{
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
  end

  defp org_id, do: Application.get_env(:tilex, :linkedin_organization_id)
end
