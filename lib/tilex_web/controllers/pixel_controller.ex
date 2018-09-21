defmodule TilexWeb.PixelController do
  use TilexWeb, :controller

  def index(conn, _) do
    Tilex.Tracking.track(conn)

    conn
    |> put_resp_header("cache-control", "no-cache, no-store, must-revalidate")
    |> send_resp(:ok, "")
  end
end
