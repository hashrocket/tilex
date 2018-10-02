defmodule Tilex.Tracking do
  alias Tilex.Repo
  alias TilexWeb.Endpoint

  @request_tracking Application.get_env(:tilex, :request_tracking, false)

  def track(conn) do
    spawn(fn ->
      if @request_tracking do
        with [referer | _] <- Plug.Conn.get_req_header(conn, "referer") do
          page = String.replace(referer, Endpoint.static_url(), "")
          Ecto.Adapters.SQL.query!(Repo, "insert into requests (page) values ($1);", [page])
        end
      end
    end)
  end
end
