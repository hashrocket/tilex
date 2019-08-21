defmodule TilexWeb.PixelController do
  use TilexWeb, :controller

  def index(conn, _) do
    Tilex.Tracking.track(conn)

    conn
    |> put_resp_header("cache-control", "no-cache, no-store, must-revalidate")
    |> put_resp_content_type("application/javascript")
    |> send_resp(:ok, "")
  end
end
