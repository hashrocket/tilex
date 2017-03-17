defmodule Tilex.Repo.Migrations.AddPublishedAtToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :published_at, :timestamptz, null: false, default: fragment("now()")
    end
  end
end
