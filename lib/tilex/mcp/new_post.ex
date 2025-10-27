defmodule Tilex.MCP.NewPost do
  @moduledoc "Post new TIL"

  use Hermes.Server.Component, type: :tool

  alias Hermes.Server.Response

  schema do
    field :title, :string, required: true
    field :content, :string, required: true
  end

  def execute(%{title: _title, content: _content}, frame) do
    response =
      Response.tool()
      |> Response.resource_link(
        "https://til.hashrocket.com/posts/nlxtvqyfl3-check-your-shell-scripts-with-shellcheck",
        "til-post",
        description: "Link to the TIL post preview"
      )

    {:reply, response, frame}
  end
end
