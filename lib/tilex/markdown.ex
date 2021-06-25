defmodule Tilex.Markdown do
  alias Tilex.Cache

  def to_html_live(markdown) do
    earmark_options = %Earmark.Options{
      code_class_prefix: "language-",
      pure_links: true,
      smartypants: false
    }

    markdown
    |> HtmlSanitizeEx.markdown_html()
    |> Earmark.as_html!(earmark_options)
    |> expand_relative_links()
    |> String.trim()
  end

  def to_html(markdown) do
    Cache.cache(markdown, fn ->
      to_html_live(markdown)
    end)
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
