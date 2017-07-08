defmodule Tilex.StatsController do
  use Tilex.Web, :controller

  def index(conn, _params) do
    Plug.Conn.assign(conn, :page_title, "Statistics")
    |> render(
           "index.html",
           Tilex.Stats.all
         )
  end
end
