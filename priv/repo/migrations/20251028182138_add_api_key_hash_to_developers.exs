defmodule Tilex.Repo.Migrations.AddApiKeyHashToDevelopers do
  use Ecto.Migration

  def change do
    alter table(:developers) do
      add :mcp_api_key, :string
    end

    create unique_index(:developers, [:mcp_api_key])
  end
end
