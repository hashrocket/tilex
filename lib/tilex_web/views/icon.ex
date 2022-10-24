defmodule TilexWeb.Icon do
  use Phoenix.HTML
  import TilexWeb.Router.Helpers, only: [static_path: 2]

  @icons_svg_file "images/icons.svg"
  @external_resource "priv/static/#{@icons_svg_file}"
  @icons_svg_content File.read!(@external_resource)
  @icon_names ~r/id="([\w-]+)"/ |> Regex.scan(@icons_svg_content) |> Enum.map(&List.last/1)
  @sizes [:small, :medium, :large]

  def icon(name, size \\ :medium, title \\ nil) when name in @icon_names and size in @sizes do
    content_tag(:svg, class: "icon icon-#{name} icon-#{size}", aria_labelledby: "title") do
      [
        content_tag(:title, title || name, lang: "en"),
        content_tag(:use, "", href: icon_path(name))
      ]
    end
  end

  defp icon_path(name), do: static_path(TilexWeb.Endpoint, "/#{@icons_svg_file}") <> "##{name}"
end
