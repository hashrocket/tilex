defmodule Tilex.MCP.Server do
  use Hermes.Server,
    name: "TIL",
    version: "1.0.0",
    capabilities: [:tools]

  component(Tilex.MCP.NewPost)
end
