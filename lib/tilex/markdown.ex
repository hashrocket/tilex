defmodule Tilex.Markdown do
  alias Tilex.Cache

  def to_html_live(markdown) do
    markdown
    |> Earmark.as_html!
    |> HtmlSanitizeEx.markdown_html
    |> String.trim
  end

  def to_html(markdown) do
    Cache.cache(markdown, fn() ->
      to_html_live(markdown)
      #|> expand_relative_links("https://til.hashrocket.com")
    end)
  end

  def expand_relative_links(dom, url) do
    dom
    |> Floki.parse
    |> Floki.map(fn(tuple) -> expand_relative_link(tuple, url) end)
    |> Floki.raw_html
  end

  defp expand_relative_link({"a", attributes}, url) do
    result_attributes = Enum.map(attributes, fn
      (attr = {"href", "http" <> _rest}) ->
        attr
      ({"href", value}) ->
        {"href", url <> value}
      (attr) ->
        attr
    end)

    {"a", result_attributes}
  end
  defp expand_relative_link({tag_name, attributes}, _), do: {tag_name, attributes}
end
