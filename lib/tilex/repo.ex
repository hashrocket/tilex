defmodule Tilex.Repo do

  @moduledoc """
    Provides the Ecto repository to wrap our data store.
  """

  use Ecto.Repo, otp_app: :tilex
end
