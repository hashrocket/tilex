defmodule Tilex.Repo.Migrations.PostsBelongToChannels do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :channel_id, references(:channels, on_delete: :delete_all)
    end
    create index(:posts, [:channel_id])
  end
end
