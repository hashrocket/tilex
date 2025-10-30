defmodule Tilex.MCP.ListChannels do
  @moduledoc """
  List channels of TIL posts.

  Channel are used to group posts by the same topic.
  """

  use Anubis.Server.Component,
    type: :resource,
    uri: "til:///channels",
    name: "list_channels",
    mime_type: "application/json"

  import Ecto.Query, only: [from: 2]

  alias Anubis.Server.Response
  alias Tilex.Blog.Channel
  alias Tilex.Repo

  @impl true
  def read(_input, frame) do
    channels = list_channels()
    resp = Response.json(Response.resource(), channels)
    {:reply, resp, frame}
  end

  defp list_channels() do
    from(c in Channel, select: c.name)
    |> Repo.all()
  end
end
