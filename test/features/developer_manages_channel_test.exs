defmodule DeveloperManagesChannelTest do
  use Tilex.IntegrationCase, async: true

  alias Tilex.Integration.Pages.Channel.IndexPage
  alias Tilex.Integration.Pages.Channel.NewPage
  alias Tilex.Integration.Pages.Channel.EditPage

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

    test "inserts new channel", %{session: session} do
      session =
        session
        |> visit(IndexPage.url())
        |> click(Query.link("New Channel"))

      assert current_path(session) == "/channels/new"
      assert get_text(session, NewPage.title_query()) == "New Channel"

      session = click(session, Query.button("Save"))

      assert get_form_errors(session, NewPage.form_query()) == [
               {"name", "can't be blank"},
               {"twitter_hashtag", "can't be blank"}
             ]

      session =
        session
        |> fill_in(Query.text_field("Name"), with: "Phoenix")
        |> fill_in(Query.text_field("Twitter hashtag"), with: "tw-phoenix")
        |> click(Query.button("Save"))

      assert current_path(session) == "/channels"

      channel = Repo.one(from(c in Channel, limit: 1))

      assert %Channel{
               name: "Phoenix",
               twitter_hashtag: "tw-phoenix"
             } = channel
    end

    test "edits a channel", %{session: session} do
      elixir_channel = Factory.insert!(Channel, name: "Elixir", twitter_hashtag: "elixir")

      session =
        session
        |> visit(IndexPage.url())
        |> click(Query.link("Edit"))

      assert current_path(session) == "/channels/#{elixir_channel.id}/edit"
      assert get_text(session, EditPage.title_query()) == "Edit Channel"

      session =
        session
        |> fill_in(Query.text_field("Name"), with: "")
        |> fill_in(Query.text_field("Twitter hashtag"), with: "")
        |> click(Query.button("Save"))

      assert get_form_errors(session, EditPage.form_query()) == [
               {"name", "can't be blank"},
               {"twitter_hashtag", "can't be blank"}
             ]

      session =
        session
        |> fill_in(Query.text_field("Name"), with: "Elixir updated")
        |> fill_in(Query.text_field("Twitter hashtag"), with: "elixir-updated")
        |> click(Query.button("Save"))

      assert current_path(session) == "/channels"

      channel = Repo.one(from(c in Channel, limit: 1))

      assert %Channel{
               name: "Elixir updated",
               twitter_hashtag: "elixir-updated"
             } = channel
    end

    test "deletes a channel", %{session: session} do
      elixir_channel = Factory.insert!(Channel, name: "Elixir", twitter_hashtag: "elixir")

      assert Repo.one(from(c in Channel, limit: 1)) == elixir_channel

      session =
        session
        |> visit(IndexPage.url())
        |> click_and_accept(Query.link("Delete"))

      assert current_path(session) == "/channels"

      assert Repo.one(from(c in Channel, limit: 1)) == nil
    end
  end
end
