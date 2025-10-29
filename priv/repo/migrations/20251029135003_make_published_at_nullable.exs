defmodule Tilex.Repo.Migrations.MakePublishedAtNullable do
  use Ecto.Migration

  def up do
    alter table(:posts) do
      modify :published_at, :timestamptz, null: true, default: nil
    end
  end

  def down do
    # Set any null published_at values to now() before re-adding NOT NULL constraint
    execute "UPDATE posts SET published_at = NOW() WHERE published_at IS NULL"

    alter table(:posts) do
      modify :published_at, :timestamptz, null: false, default: fragment("now()")
    end
  end
end
