defmodule Tilex.Repo.Migrations.AddDeveloperIdToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :developer_id, references(:developers, on_delete: :delete_all)
    end
    create index(:posts, [:developer_id])
  end
end
