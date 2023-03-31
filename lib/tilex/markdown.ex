defmodule Tilex.Markdown do
  alias Tilex.Cache
  alias Tilex.Blog.PostScrubber
  alias HtmlSanitizeEx.Scrubber

  @earmark_options %Earmark.Options{
    code_class_prefix: "language-",
    escape: true,
    pure_links: false,
    smartypants: false
  }

  @content_earmark_options %Earmark.Options{
    code_class_prefix: "language-",
    escape: false,
    pure_links: false,
    smartypants: false
  }

  def to_html_live(markdown) do
    markdown
    |> Earmark.as_html!(@earmark_options)
    |> sanitize_markdown_html()
    |> String.trim()
  end

  def to_html(markdown), do: Cache.cache(markdown, fn -> to_html_live(markdown) end)

  def to_content(markdown) do
    markdown
    |> Earmark.as_html!(@content_earmark_options)
    |> sanitize_markdown_html()
    |> Floki.parse_fragment()
    |> case do
      {:ok, fragment} -> fragment |> Floki.text() |> String.trim()
      _error -> markdown
    end
  end

  defp sanitize_markdown_html(html), do: Scrubber.scrub(html, PostScrubber)
end
