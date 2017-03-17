defmodule Tilex.Repo.Migrations.AddMaxLikesToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :max_likes, :integer, default: 1, null: false
    end
  end
end
