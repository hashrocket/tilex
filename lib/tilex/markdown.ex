defmodule Tilex.Markdown do
  def to_html_live(markdown) do
    markdown
    |> Earmark.as_html!
    |> HtmlSanitizeEx.markdown_html
  end

  def to_html(markdown) do
    Tilex.Cache.cache(markdown, fn()->
      to_html_live(markdown)
    end)
  end
end
