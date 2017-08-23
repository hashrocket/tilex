defmodule Tilex.Repo.Migrations.UpdateTextEditorOnDevelopers do
  use Ecto.Migration

  def up do
    execute """
    update developers set editor = 'Vim' where editor = 'Ace (w/ Vim)';
    """

    execute """
    update developers set editor = 'Code Editor' where editor = 'Ace';
    """
  end

  def down do
    execute """
    update developers set editor = 'Ace (w/ Vim)' where editor = 'Vim';
    """

    execute """
    update developers set editor = 'Ace' where editor = 'Code Editor';
    """
  end
end
