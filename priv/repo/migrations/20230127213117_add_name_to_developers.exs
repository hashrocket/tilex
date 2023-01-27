defmodule Tilex.Repo.Migrations.AddNameToDevelopers do
  use Ecto.Migration

  def change do
    alter table(:developers) do
      add(:name, :text)
    end
  end
end
