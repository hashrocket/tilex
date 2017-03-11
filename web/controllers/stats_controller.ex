defmodule Tilex.StatsController do
  use Tilex.Web, :controller

  def index(conn, params) do
    render(conn, "index.html")
  end
end
