defmodule Lib.Tilex.MarkdownTest do
  use ExUnit.Case, async: true

  alias Tilex.Markdown

  @to_html_data [
    %{
      input: "",
      expected: ""
    },
    %{
      input: "Some text",
      expected: "<p>Some text</p>"
    },
    %{
      input: "```\nsome code block\n```",
      expected: "<pre><code class=\" language-\">some code block</code></pre>"
    },
    %{
      input: "```elixir\ndefmodule Foo do\nend\n```",
      expected: "<pre><code class=\"elixir language-elixir\">defmodule Foo do\nend</code></pre>"
    },
    %{
      input: "<script>alert('A great grasshopper!')</script>",
      expected: "<p>alert(‘A great grasshopper!’)</p>"
    },
    %{
      input: "Some http://link.com?foo=bar",
      expected: "<p>Some http://link.com?foo=bar</p>"
    },
    %{
      input: "Some /link.com?foo=bar",
      expected: "<p>Some /link.com?foo=bar</p>"
    },
    %{
      input: "some [Link](http://link.com?foo=bar)",
      expected: "<p>some <a href=\"http://link.com?foo=bar\">Link</a></p>"
    },
    %{
      input: "some [Relative Link](/link.com?foo=bar)",
      expected:
        "<p>some <a href=\"https://til.hashrocket.com/link.com?foo=bar\">Relative Link</a></p>"
    },
    %{
      input: "some <a href=\"http://link.com?foo=bar\">Link</a>",
      expected: "<p>some <a href=\"http://link.com?foo=bar\">Link</a></p>"
    },
    %{
      input: "some <a href=\"/link.com?foo=bar\">Link</a>",
      expected: "<p>some <a href=\"https://til.hashrocket.com/link.com?foo=bar\">Link</a></p>"
    },
    %{
      input: "```\n# some http://link.com?foo=bar\n```",
      expected: "<pre><code class=\" language-\"># some http://link.com?foo=bar</code></pre>"
    },
    %{
      input: "```\n# some /link.com?foo=bar\n```",
      expected: "<pre><code class=\" language-\"># some /link.com?foo=bar</code></pre>"
    }
  ]

  describe "to_html_live/1" do
    for %{input: input, expected: expected} <- @to_html_data do
      @input input
      @expected expected

      test "converts markdown '#{inspect(@input)}' into html" do
        assert Markdown.to_html_live(@input) == @expected
      end
    end
  end

  describe "to_html/1" do
    for %{input: input, expected: expected} <- @to_html_data do
      @input input
      @expected expected

      test "converts markdown '#{inspect(@input)}' into html" do
        assert Markdown.to_html(@input) == @expected
      end
    end
  end
end
