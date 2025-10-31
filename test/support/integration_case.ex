defmodule Tilex.IntegrationCase do
  use ExUnit.CaseTemplate

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
end
