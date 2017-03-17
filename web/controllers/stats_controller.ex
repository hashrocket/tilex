defmodule Tilex.StatsController do
  use Tilex.Web, :controller

  def index(conn, _params) do
    render(
           conn,
           "index.html",
           Tilex.Stats.all
         )
  end
end
