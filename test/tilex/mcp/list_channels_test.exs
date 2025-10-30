defmodule Tilex.MCP.ListChannelsTest do
  use Tilex.DataCase, async: false

  alias Anubis.Server.Response
  alias Tilex.Factory
  alias Tilex.MCP.ListChannels

  @frame %{assigns: %{}}
  @input %{}

  describe "execute/2" do
    test "returns list of channel names when channels exist" do
      Factory.insert!(:channel, name: "elixir")
      Factory.insert!(:channel, name: "ruby")
      Factory.insert!(:channel, name: "javascript")

      assert {:reply, response, returned_frame} = ListChannels.read(@input, @frame)

      assert returned_frame == @frame

      assert %Response{
               type: :resource,
               isError: false,
               contents: %{"text" => content}
             } = response

      assert content == "[\"elixir\",\"ruby\",\"javascript\"]"
    end

    test "returns empty list when no channels exist" do
      assert {:reply, response, returned_frame} = ListChannels.read(@input, @frame)

      assert returned_frame == @frame

      assert %Response{
               type: :resource,
               isError: false,
               contents: %{"text" => content}
             } = response

      assert content == "[]"
    end
  end
end
