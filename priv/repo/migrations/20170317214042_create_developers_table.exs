defmodule Tilex.Repo.Migrations.CreateDevelopersTable do
  use Ecto.Migration

  def change do
    create table(:developers) do
      add :email, :varchar, null: false
      add :username, :varchar, null: false
      add :google_id, :varchar, null: false

      timestamps()
    end
  end
end
