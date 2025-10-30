defmodule Tilex.MCP.Server do
  use Anubis.Server, name: "TIL", version: "1.0.0", capabilities: [:resources, :tools]

  component(Tilex.MCP.ListChannels)
  component(Tilex.MCP.NewPost)
end
