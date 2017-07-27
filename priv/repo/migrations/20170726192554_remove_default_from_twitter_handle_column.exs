defmodule Tilex.Repo.Migrations.RemoveDefaultFromTwitterHandleColumn do
  use Ecto.Migration

  def up do
    execute """
      alter table developers alter twitter_handle drop default;
    """
  end

  def down do
    execute """
      alter table developers alter twitter_handle set default 'hashrocket';
    """
  end
end
