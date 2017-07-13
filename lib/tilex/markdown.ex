defmodule Tilex.Markdown do

  def to_html(markdown) do
    markdown
    |> Earmark.as_html!
    |> HtmlSanitizeEx.markdown_html
  end
end
