defmodule TilexWeb.StatsController do
  use TilexWeb, :controller

  alias Tilex.Stats

  def index(conn, _params) do
    conn
    |> assign(:page_title, "Statistics")
    |> render("index.html", Stats.all)
  end
end
