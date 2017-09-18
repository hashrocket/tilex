defmodule Tilex.WebManifestControllerTest do
  use TilexWeb.ConnCase, async: true

  test "index returns web manifest json", %{conn: conn} do
    organization_name = Application.get_env(:tilex, :organization_name)
    conn = get(conn, web_manifest_path(conn, :index))
    assert json_response(conn, 200)["short_name"] == "TIL - #{organization_name}"
    assert json_response(conn, 200)["name"] == "Today I Learned - #{organization_name}"
  end
end
