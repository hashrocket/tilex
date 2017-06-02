defmodule Tilex.Repo.Migrations.AddEditorToDevelopers do
  use Ecto.Migration

  def change do
    alter table(:developers) do
      add :editor, :string, default: "Text Field"
    end
  end
end
