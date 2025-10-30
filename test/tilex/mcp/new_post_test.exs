defmodule Tilex.MCP.NewPostTest do
  use Tilex.DataCase, async: false

  alias Anubis.Server.Response
  alias Tilex.Blog.Developer
  alias Tilex.Blog.Post
  alias Tilex.Factory
  alias Tilex.MCP.NewPost
  alias Tilex.Repo

  describe "execute/2" do
    setup do
      %{
        mcp_api_key: mcp_api_key,
        signed_token: signed_token
      } = Developer.generate_mcp_api_key(TilexWeb.Endpoint)

      developer = Factory.insert!(:developer, mcp_api_key: mcp_api_key)

      [developer: developer, signed_token: signed_token]
    end

    test "creates post successfully with valid data and authenticated user", %{
      developer: developer,
      signed_token: signed_token
    } do
      channel = Factory.insert!(:channel, name: "elixir")

      title = "My First TIL"
      body = "Today I learned something amazing about Elixir."
      channel_id = channel.id
      developer_id = developer.id

      input = %{
        channel: channel.name,
        title: title,
        body: body
      }

      frame = %{transport: %{req_headers: %{"x-api-key" => signed_token}}}

      assert {:reply, response, returned_frame} = NewPost.execute(input, frame)

      assert returned_frame == frame

      assert %Response{
               type: :tool,
               isError: false,
               content: [
                 %{
                   "description" => "Open this link in order to review the TIL and publish it!",
                   "name" => "til-post",
                   "type" => "resource_link",
                   "uri" => "http" <> _
                 }
               ]
             } = response

      assert [post] = Repo.all(Post)

      assert %Post{
               channel_id: ^channel_id,
               title: ^title,
               body: ^body,
               developer_id: ^developer_id
             } = post
    end

    test "returns error when user is not authenticated" do
      channel = Factory.insert!(:channel, name: "elixir")

      title = "My First TIL"
      body = "Today I learned something amazing about Elixir."

      input = %{
        channel: channel.name,
        title: title,
        body: body
      }

      frame = %{transport: %{req_headers: %{}}}

      assert {:reply, response, returned_frame} = NewPost.execute(input, frame)

      assert returned_frame == frame

      assert %Response{
               type: :tool,
               isError: true,
               content: [
                 %{
                   "text" => "ERROR => User is not authenticated to create TILs",
                   "type" => "text"
                 }
               ]
             } = response
    end

    test "raises error when channel does not exist", %{signed_token: signed_token} do
      title = "My First TIL"
      body = "Today I learned something amazing about Elixir."

      input = %{
        channel: "missing-channel",
        title: title,
        body: body
      }

      frame = %{transport: %{req_headers: %{"x-api-key" => signed_token}}}

      assert {:reply, response, returned_frame} = NewPost.execute(input, frame)

      assert returned_frame == frame

      assert %Response{
               type: :tool,
               isError: true,
               content: [
                 %{
                   "text" => "ERROR => Channel does not exist: missing-channel",
                   "type" => "text"
                 }
               ]
             } = response
    end

    test "returns validation error", %{signed_token: signed_token} do
      channel = Factory.insert!(:channel, name: "elixir")

      title = String.duplicate("a", 51)
      body = String.duplicate("word ", 201)

      input = %{
        channel: channel.name,
        title: title,
        body: body
      }

      frame = %{transport: %{req_headers: %{"x-api-key" => signed_token}}}

      assert {:reply, response, returned_frame} = NewPost.execute(input, frame)

      assert returned_frame == frame

      assert %Response{
               type: :tool,
               isError: true,
               content: [
                 %{
                   "text" =>
                     "Title should be at most 50 character(s)\nBody should be at most 200 word(s)",
                   "type" => "text"
                 }
               ]
             } = response
    end
  end
end
