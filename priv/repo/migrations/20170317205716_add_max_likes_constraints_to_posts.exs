defmodule Tilex.Repo.Migrations.AddMaxLikesConstraintsToPosts do
  use Ecto.Migration

  def change do
    create constraint(:posts, "max_likes_must_be_greater_than_zero", check: "max_likes > 0")
  end
end
