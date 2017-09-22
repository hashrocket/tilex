defmodule TilexWeb.WebManifestController do
  use TilexWeb, :controller

  def index(conn, _) do
    conn
    |> assign(:organization_name, Application.get_env(:tilex, :organization_name))
    |> render("manifest.json")
  end
end
