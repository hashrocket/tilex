defmodule Tilex.Repo.Migrations.CreateTracking do
  use Ecto.Migration

  def up do
    execute """
      create table requests (page text not null, request_time timestamp with time zone default now());
    """
  end

  def down do
    execute """
      drop table requests;
    """
  end
end
