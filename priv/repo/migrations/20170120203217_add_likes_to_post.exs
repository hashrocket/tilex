defmodule Tilex.Repo.Migrations.AddLikesToPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :likes, :integer, default: 1, null: false
    end
    create constraint(:posts, "likes_must_be_greater_than_zero", check: "likes > 0")
  end
end
