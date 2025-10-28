defmodule Tilex.MCP.ListChannelsTest do
  use Tilex.DataCase, async: false

  alias Hermes.Server.Response
  alias Tilex.Factory
  alias Tilex.MCP.ListChannels

  @frame %{assigns: %{}}
  @input %{}

  describe "execute/2" do
    test "returns list of channel names when channels exist" do
      Factory.insert!(:channel, name: "elixir")
      Factory.insert!(:channel, name: "ruby")
      Factory.insert!(:channel, name: "javascript")

      assert {:reply, response, returned_frame} = ListChannels.execute(@input, @frame)

      assert returned_frame == @frame

      assert %Response{
               type: :tool,
               isError: false,
               content: [content]
             } = response

      assert %{
               "text" => "[\"elixir\",\"ruby\",\"javascript\"]",
               "type" => "text"
             } == content
    end

    test "returns empty list when no channels exist" do
      assert {:reply, response, returned_frame} = ListChannels.execute(@input, @frame)

      assert returned_frame == @frame

      assert %Response{
               type: :tool,
               isError: false,
               content: [content]
             } = response

      assert %{
               "text" => "[]",
               "type" => "text"
             } == content
    end
  end
end
