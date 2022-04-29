defmodule Tilex.Repo.Migrations.AddRequestTimeInApplicationTimezoneIndexToRequests do
  use Ecto.Migration

  @disable_ddl_transaction true
  @disable_migration_lock true

  def up do
    application_timezone = Application.get_env(:tilex, :date_display_tz, "america/chicago")
                           |> String.downcase()
    execute """
      drop index concurrently if exists index_requests_on_request_time_in_chicago
    """

    execute """
      create index concurrently if not exists index_requests_on_request_time_in_app_tz on requests (timezone('#{application_timezone}', request_time))
    """
  end

  def down do
    execute """
      drop index concurrently if exists index_requests_on_request_time_in_app_tz
    """

    execute """
      create index concurrently if not exists index_requests_on_request_time_in_chicago on requests (timezone('america/chicago', request_time))
    """
  end
end
