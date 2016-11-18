defmodule TodayILearned.IntegrationCase do

  use ExUnit.CaseTemplate
  use Hound.Helpers

  using do
    quote do
      use Hound.Helpers

      import Ecto, only: [build_assoc: 2]
      import Ecto.Model
      import Ecto.Query, only: [from: 2]
      import TodayILearned.Router.Helpers
      import TodayILearned.IntegrationCase

      alias TodayILearned.Repo

      # The default endpoint for testing
      @endpoint TodayILearned.Endpoint

      hound_session
    end
  end
end
