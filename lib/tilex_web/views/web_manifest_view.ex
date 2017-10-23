defmodule TilexWeb.WebManifestView do
  use TilexWeb, :view

  def render("manifest.json", %{conn: conn, organization_name: organization_name}) do
    %{
      short_name: "TIL - #{organization_name}",
      name: "Today I Learned - #{organization_name}",
      icons: [
        %{
          src: "apple-touch-icon.png",
          type: "image/png",
          sizes: "100x100"
        },
        %{
          src: "apple-touch-icon-120x120.png",
          type: "image/png",
          sizes: "120x120"
        },
        %{
          src: static_path(conn, "/images/til-logo-144x144.png"),
          type: "image/png",
          sizes: "144x144"
        },
        %{
          src: static_path(conn, "/images/til-logo-512x512.png"),
          type: "image/png",
          sizes: "512x512"
        }
      ],
      start_url: "/",
      background_color: "#d5e9f5",
      theme_color: "#d5e9f5",
      display: "standalone"
    }
  end
end
