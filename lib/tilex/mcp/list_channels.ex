defmodule Tilex.MCP.ListChannels do
  @moduledoc """
  List channels of TIL posts.

  Channel are used to group posts by the same topic.
  """

  use Hermes.Server.Component, type: :tool

  import Ecto.Query, only: [from: 2]

  alias Hermes.Server.Response
  alias Tilex.Blog.Channel
  alias Tilex.Repo

  schema do
  end

  def execute(input, frame) do
    channels = list_channels()
    resp = Response.tool() |> Response.json(channels)
    {:reply, resp, frame}
  end

  defp list_channels() do
    from(c in Channel, select: c.name)
    |> Repo.all()
  end
end
