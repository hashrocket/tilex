defmodule Tilex.Repo.Migrations.AddTweetedToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :tweeted, :boolean, null: false, default: false
    end
  end
end
