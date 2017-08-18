defmodule TilexWeb.StatsController do

  @moduledoc """
    Provides support for Tilex statistics.
  """

  use TilexWeb, :controller

  def index(conn, _params) do
    conn
    |> assign(:page_title, "Statistics")
    |> render("index.html", Tilex.Stats.all)
  end
end
