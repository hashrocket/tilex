defmodule Tilex.Repo.Migrations.AddTweetedAtToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      remove :tweeted
      add :tweeted_at, :timestamptz
    end
  end
end
