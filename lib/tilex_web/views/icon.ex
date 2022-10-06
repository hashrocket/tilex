defmodule TilexWeb.Icon do
  use Phoenix.HTML
  import TilexWeb.Router.Helpers, only: [static_path: 2]

  @icons_svg_file "images/icons.svg"
  @external_resource "assets/static/#{@icons_svg_file}"
  @icons_svg_content File.read!(@external_resource)

  @icon_names ~r/id="([\w-]+)"/
              |> Regex.scan(@icons_svg_content)
              |> Enum.map(&List.last/1)

  def icon(name, size \\ :regular, title \\ nil) do
    size_value = get_size(size)
    title = title || name

    content_tag(:svg,
      class: "icon icon-#{name}",
      width: size_value,
      height: size_value,
      aria_labelledby: "title"
    ) do
      [
        content_tag(:title, title, lang: "en"),
        content_tag(:use, "", href: icon_path(name))
      ]
    end
  end

  defp get_size(:small), do: "1.8rem"
  defp get_size(:regular), do: "2.4rem"
  defp get_size(:large), do: "3.2rem"

  defp icon_path(name) when name in @icon_names do
    static_path(TilexWeb.Endpoint, "/#{@icons_svg_file}") <> "##{name}"
  end
end
