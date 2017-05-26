defmodule Tilex.Markdown do

  def to_html(markdown) do
    markdown
    |> Earmark.as_html!
    |> HtmlSanitizeEx.basic_html
  end
end
