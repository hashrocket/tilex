defmodule Tilex.ErrorViewTest do
  use TilexWeb.ConnCase, async: true

  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(TilexWeb.ErrorView, "404.html", []) =~ "no page at this URL"
  end

  test "render 500.html" do
    assert render_to_string(TilexWeb.ErrorView, "500.html", []) =~ "something is broken"
  end

  test "render any other" do
    assert render_to_string(TilexWeb.ErrorView, "505.html", []) =~ "something is broken"
  end
end
