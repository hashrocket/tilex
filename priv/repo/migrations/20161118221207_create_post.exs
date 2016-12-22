defmodule Tilex.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :varchar, null: false
      add :body, :text, null: false

      add :inserted_at, :timestamptz, null: false, default: fragment("now()")
      add :updated_at, :timestamptz, null: false, default: fragment("now()")
    end
  end
end
