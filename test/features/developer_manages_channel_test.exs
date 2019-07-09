defmodule DeveloperManagesChannelTest do
  use Tilex.IntegrationCase, async: true

  alias Tilex.Integration.Pages.Channel.IndexPage

  describe "when developer is not authenticated" do
    test "redirects user to the home page", %{session: session} do
      session = visit(session, IndexPage.url())

      assert current_path(session) == "/"
    end
  end

  describe "when developer is authenticated" do
    setup [:authenticated_developer]

    test "lists all channels", %{session: session} do
      elixir_channel = Factory.insert!(Channel, name: "Elixir", twitter_hashtag: "elixir")
      Factory.insert!(Channel, name: "Javascript", twitter_hashtag: "js")
      Factory.insert!(:post, channel_id: elixir_channel.id)

      session = visit(session, IndexPage.url())

      assert current_path(session) == "/channels"
      assert get_text(session, IndexPage.title_query()) == "Listing Channels"

      assert get_table_texts(session, IndexPage.table_query()) == [
               ["Name", "Twitter hashtag", "Posts Count", ""],
               ["Elixir", "elixir", "1", "Edit Delete"],
               ["Javascript", "js", "0", "Edit Delete"]
             ]
    end
  end
end
