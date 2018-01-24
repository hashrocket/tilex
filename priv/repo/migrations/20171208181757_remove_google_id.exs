defmodule Tilex.Repo.Migrations.RemoveGoogleId do
  use Ecto.Migration

  def up do
    execute """
      alter table developers drop column google_id;
    """
  end

  def down do
    execute """
      alter table developers add column google_id varchar;
    """
  end
end
