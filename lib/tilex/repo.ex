defmodule Tilex.Repo do
  use Ecto.Repo,
    otp_app: :tilex,
    adapter: Ecto.Adapters.Postgres
end
