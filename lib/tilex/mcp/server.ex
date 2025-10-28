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
    assigns = Map.put(frame.assigns, :current_user, user)
    frame = Map.put(frame, :assigns, assigns)
    {:ok, frame}
  end

  defp get_current_user("" <> _ = api_key) do
    Repo.one(from d in Developer, where: d.id == ^api_key)
  end

  defp get_current_user(_api_key), do: nil
end
