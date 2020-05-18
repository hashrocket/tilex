defmodule Tilex.Repo.Migrations.AddIndexToRequestTimeOnRequests do
  use Ecto.Migration

  def change do
    create(index(:requests, :request_time))
  end
end
