defmodule Tilex.Repo.Migrations.AddIndexToRequests do
  use Ecto.Migration

  def change do
    create(index(:requests, :page))
  end
end
