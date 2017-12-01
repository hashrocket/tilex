defmodule Tilex.IntegrationCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL
      alias Wallaby.Query
      alias Wallaby.Element

      alias Tilex.{Channel, Factory, Post, Repo}
      alias TilexWeb.Endpoint
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import TilexWeb.Router.Helpers
      import Tilex.TestHelpers

      def sign_in(session, developer) do
        visit(session, "/admin?id=#{developer.id}")
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Tilex.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Tilex.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Tilex.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
