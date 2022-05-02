defmodule Tilex.Repo.Migrations.AddRequestTimeInChicagoTzIndexToRequests do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    execute """
      create index concurrently index_requests_on_request_time_in_chicago on requests (timezone('america/chicago', request_time))
    """
  end

  def down do
    execute """
      drop index concurrently index_requests_on_request_time_in_chicago
    """
  end
end
