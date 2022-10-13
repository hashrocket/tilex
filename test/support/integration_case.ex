defmodule Tilex.IntegrationCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL
      alias Wallaby.Query
      alias Wallaby.Element

      alias Tilex.Blog.Channel
      alias Tilex.Factory
      alias Tilex.Blog.Post
      alias Tilex.Repo
      alias TilexWeb.Endpoint
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import TilexWeb.Router.Helpers
      import Tilex.WallabyTestHelpers

      def sign_in(session, developer) do
        visit(session, "/admin?id=#{developer.id}")
      end

      def authenticated_developer(%{session: session}) do
        developer = Factory.insert!(:developer, admin: true, username: "Rock Teer")
        [session: sign_in(session, developer), developer: developer]
      end
    end
  end

  setup tags do
    Tilex.DataCase.setup_sandbox(tags)
    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Tilex.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
