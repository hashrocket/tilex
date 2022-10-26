defmodule Tilex.Markdown do
  alias Tilex.Cache

  @earmark_options %Earmark.Options{
    code_class_prefix: "language-",
    pure_links: true
  }

  @tw_earmark_options %Earmark.Options{pure_links: false}

  def to_html_live(markdown) do
    markdown
    |> Earmark.as_html!(@earmark_options)
    |> HtmlSanitizeEx.markdown_html()
    |> expand_relative_links()
    |> String.trim()
  end

  def to_html(markdown) do
    Cache.cache(markdown, fn ->
      to_html_live(markdown)
    end)
  end

  def to_content(markdown) do
    with {:ok, html, _errors} <- Earmark.as_html(markdown, @tw_earmark_options),
         {:ok, fragment} <- Floki.parse_fragment(html) do
      Floki.text(fragment)
    else
      _error -> markdown
    end
  end

  defp expand_relative_links(dom) do
    {:ok, fragment} = Floki.parse_fragment(dom)

    fragment
    |> Floki.find_and_update("a", &expand_relative_link/1)
    |> Floki.raw_html()
  end

  defp expand_relative_link({"a", attrs}), do: {"a", Enum.map(attrs, &expand_link_attribute/1)}
  defp expand_relative_link({tag_name, attrs}), do: {tag_name, attrs}

  defp expand_link_attribute({"href", "http" <> _rest} = attr), do: attr
  defp expand_link_attribute({"href", value}), do: {"href", base_url() <> value}
  defp expand_link_attribute(attr), do: attr

  defp base_url(), do: Application.get_env(:tilex, :canonical_domain)
end
