defmodule TilexWeb.Icon do
  use Phoenix.HTML
  import TilexWeb.Router.Helpers, only: [static_path: 2]

  @icons_svg_file "images/icons.svg"
  @external_resource "assets/static/#{@icons_svg_file}"
  @icons_svg_content File.read!(@external_resource)

  @icon_names ~r/id="([\w-]+)"/
              |> Regex.scan(@icons_svg_content)
              |> Enum.map(&List.last/1)

  def icon(name, size \\ :regular) do
    size_value = get_size(size)

    content_tag(:svg, class: "icon icon-#{name}", width: size_value, height: size_value) do
      content_tag(:use, "", href: icon_path(name))
    end
  end

  defp get_size(:small), do: 18
  defp get_size(:regular), do: 24
  defp get_size(:large), do: 32

  defp icon_path(name) when name in @icon_names do
    static_path(TilexWeb.Endpoint, "/#{@icons_svg_file}") <> "##{name}"
  end
end
