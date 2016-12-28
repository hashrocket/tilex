defmodule Tilex.Repo.Migrations.CreateChannel do
  use Ecto.Migration

  def change do
    create table(:channels) do
      add :name, :string, null: false
      add :twitter_hashtag, :string, null: false

      timestamps()
    end
  end
end
