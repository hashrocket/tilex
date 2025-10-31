defmodule Tilex.IntegrationCase do
  use ExUnit.CaseTemplate

  alias Wallaby.Browser
  alias Wallaby.Element
  alias Wallaby.Query

  using do
    quote do
      use Wallaby.Feature

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Tilex.IntegrationCase
      import Tilex.WallabyTestHelpers
      import TilexWeb.Router.Helpers

      alias Tilex.Blog.Channel
      alias Tilex.Blog.Post
      alias Tilex.Factory
      alias Tilex.Repo
      alias TilexWeb.Endpoint
      alias Wallaby.Element
      alias Wallaby.Query

      def sign_in(session, developer) do
        visit(session, "/admin?id=#{developer.id}")
      end

      def authenticated_developer(%{session: session}) do
        developer = Factory.insert!(:developer, admin: true, username: "Rock Teer")
        [session: sign_in(session, developer), developer: developer]
      end

      setup do
        Ecto.Adapters.SQL.Sandbox.allow(Tilex.Repo, self(), Process.whereis(Tilex.Notifications))
      end
    end
  end

  def click_and_confirm(session, query) do
    Browser.accept_confirm(session, &Browser.click(&1, query))
    session
  end

  def assert_path(session, path) do
    retry!(session, fn ->
      assert Browser.current_path(session) == path
      session
    end)
  end

  def assert_contains(session, query, expected_text) do
    retry!(session, fn ->
      texts = session |> Browser.all(query) |> Enum.map(&Element.text/1)

      assert Enum.any?(texts, &String.contains?(&1, expected_text)),
             "Unable to find contains text: '#{expected_text}', instead found '#{texts}'"

      session
    end)
  end

  def assert_texts(session, query, expected_texts) do
    retry!(session, fn ->
      texts = session |> Browser.all(query) |> Enum.map(&Element.text/1)

      assert texts == expected_texts,
             "Unable to find text: '#{expected_texts}', instead found '#{texts}'"

      session
    end)
  end

  def assert_flash(session, level, message) when level in [:info, :success] do
    assert_contains(session, Query.css(".alert-#{level}"), message)
  end

  @waits [10, 20, 30, 50, 80, 130]
  def retry!(session, func, waits \\ @waits) do
    func.()
    session
  rescue
    error ->
      case waits do
        [] ->
          reraise(error, __STACKTRACE__)

        [wait | waits] ->
          Process.sleep(wait)
          retry!(session, func, waits)
      end
  end
end
