defmodule Tilex.MCP.ServerTest do
  use Tilex.DataCase, async: true

  alias Tilex.Blog.Developer
  alias Tilex.Factory
  alias Tilex.MCP.Server

  describe "MCP server authentication" do
    test "valid API key authenticates developer" do
      %{
        mcp_api_key: mcp_api_key,
        signed_token: signed_token
      } = Developer.generate_mcp_api_key(TilexWeb.Endpoint)

      developer = Factory.insert!(:developer, mcp_api_key: mcp_api_key)
      developer_id = developer.id

      frame = %{
        transport: %{
          req_headers: [{"x-api-key", signed_token}]
        },
        assigns: %{}
      }

      assert {:ok, frame} = Server.init(nil, frame)

      assert %{
               current_user: %Tilex.Blog.Developer{
                 id: ^developer_id
               }
             } = frame.assigns
    end

    test "invalid API key fails authentication" do
      %{
        mcp_api_key: _old_mcp_api_key,
        signed_token: old_signed_token
      } = Developer.generate_mcp_api_key(TilexWeb.Endpoint)

      %{
        mcp_api_key: mcp_api_key,
        signed_token: _signed_token
      } = Developer.generate_mcp_api_key(TilexWeb.Endpoint)

      Factory.insert!(:developer, mcp_api_key: mcp_api_key)

      frame = %{
        transport: %{
          req_headers: [{"x-api-key", old_signed_token}]
        },
        assigns: %{}
      }

      assert {:ok, frame} = Server.init(nil, frame)
      assert %{current_user: nil} = frame.assigns
    end
  end
end
