defmodule Tilex.IntegrationCase do

  use ExUnit.CaseTemplate
  use Hound.Helpers

  using do
    quote do
      use Hound.Helpers

      import Ecto, only: [build_assoc: 2]
      import Ecto.Model
      import Ecto.Query, only: [from: 2]
      import Tilex.Router.Helpers
      import Tilex.IntegrationCase

      alias Tilex.Repo

      # The default endpoint for testing
      @endpoint Tilex.Endpoint

      hound_session
    end
  end
end
