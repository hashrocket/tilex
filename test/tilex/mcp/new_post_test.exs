defmodule Tilex.MCP.NewPostTest do
  use Tilex.DataCase, async: false

  alias Hermes.Server.Response
  alias Tilex.Blog.Post
  alias Tilex.Factory
  alias Tilex.MCP.NewPost
  alias Tilex.Repo

  describe "execute/2" do
    test "creates post successfully with valid data and authenticated user" do
      developer = Factory.insert!(:developer)
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

      frame = %{assigns: %{current_user: developer}}

      assert {:reply, response, returned_frame} = NewPost.execute(input, frame)

      assert returned_frame == frame

      assert %Response{
               type: :tool,
               isError: false,
               content: [
                 %{
                   "description" => "Link to the TIL post preview",
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

      frame = %{assigns: %{}}

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

    test "raises error when channel does not exist" do
      developer = Factory.insert!(:developer)

      title = "My First TIL"
      body = "Today I learned something amazing about Elixir."

      input = %{
        channel: "missing-channel",
        title: title,
        body: body
      }

      frame = %{assigns: %{current_user: developer}}

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

    test "returns validation error" do
      developer = Factory.insert!(:developer)
      channel = Factory.insert!(:channel, name: "elixir")

      title = String.duplicate("a", 51)
      body = String.duplicate("word ", 201)

      input = %{
        channel: channel.name,
        title: title,
        body: body
      }

      frame = %{assigns: %{current_user: developer}}

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
