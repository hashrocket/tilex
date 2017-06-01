defmodule Tilex.Repo.Migrations.AddAdminToDevelopers do
  use Ecto.Migration

  def change do
    alter table(:developers) do
      add :admin, :boolean, default: false
    end
  end
end
