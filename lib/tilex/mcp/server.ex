defmodule Tilex.MCP.Server do
  use Hermes.Server, name: "TIL", version: "1.0.0", capabilities: [:tools]

  import Ecto.Query, only: [from: 2]

  alias Tilex.Repo
  alias Tilex.Blog.Developer

  component(Tilex.MCP.ListChannels)
  component(Tilex.MCP.NewPost)

  def init(_arg, frame) do
    headers = Enum.into(frame.transport.req_headers, %{})
    user = get_current_user(headers["x-api-key"])
    assigns = Map.put(frame.assigns || %{}, :current_user, user)
    frame = Map.put(frame, :assigns, assigns)
    {:ok, frame}
  end

  defp get_current_user(signed_token) do
    with "" <> _ <- signed_token,
         {:ok, mcp_api_key} <- Developer.verify_mcp_api_key(TilexWeb.Endpoint, signed_token) do
      Repo.one(from d in Developer, where: d.mcp_api_key == ^mcp_api_key)
    else
      _ -> nil
    end
  end
end
