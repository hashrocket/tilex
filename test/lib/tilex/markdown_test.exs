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
      expected: "<p>\nSome text</p>"
    },
    %{
      input: "Some\ntext",
      expected: "<p>\nSome\ntext</p>"
    },
    %{
      input: "Some<br />text",
      expected: "<p>\nSome<br/>text</p>"
    },
    %{
      input: "Some\n\ntext",
      expected: "<p>\nSome</p><p>\ntext</p>"
    },
    %{
      input: "```\ncode block\n```",
      expected: "<pre><code>code block</code></pre>"
    },
    %{
      input: "```elixir\ndefmodule Foo do\nend\n```",
      expected: "<pre><code class=\"elixir language-elixir\">defmodule Foo do\nend</code></pre>"
    },
    %{
      input: "```elixir\niex> IO.inspect(\"Hello World!\")\n```",
      expected:
        "<pre><code class=\"elixir language-elixir\">iex&gt; IO.inspect(&quot;Hello World!&quot;)</code></pre>"
    },
    %{
      input: "<script>alert('some attack')</script>",
      expected: "<p>\nalert(‘some attack’)</p>"
    },
    %{
      input: "Some http://link.com?foo=bar",
      expected: "<p>\nSome http://link.com?foo=bar</p>"
    },
    %{
      input: "Some /link.com?foo=bar",
      expected: "<p>\nSome /link.com?foo=bar</p>"
    },
    %{
      input: "some [Link](http://link.com?foo=bar)",
      expected: "<p>\nsome <a href=\"http://link.com?foo=bar\">Link</a></p>"
    },
    %{
      input: "some [Relative Link](/link.com?foo=bar)",
      expected:
        "<p>\nsome <a href=\"https://til.hashrocket.com/link.com?foo=bar\">Relative Link</a></p>"
    },
    %{
      input: "Here's [my-link]\n\n[my-link]: http://foo/bar",
      expected: "<p>\nHere’s <a href=\"http://foo/bar\" title=\"\">my-link</a></p>"
    },
    %{
      input: "Here's [my-link]\n\n[my-link]: http://foo/bar \"With Title\"",
      expected: "<p>\nHere’s <a href=\"http://foo/bar\" title=\"With Title\">my-link</a></p>"
    },
    %{
      input: "some <a href=\"http://link.com?foo=bar\">Link</a>",
      expected: "<p>\nsome <a href=\"http://link.com?foo=bar\">Link</a></p>"
    },
    %{
      input: "some <a href=\"/link.com?foo=bar\">Link</a>",
      expected: "<p>\nsome <a href=\"https://til.hashrocket.com/link.com?foo=bar\">Link</a></p>"
    },
    %{
      input: "```\n# some http://link.com?foo=bar\n```",
      expected: "<pre><code># some http://link.com?foo=bar</code></pre>"
    },
    %{
      input: "```\n# some /link.com?foo=bar\n```",
      expected: "<pre><code># some /link.com?foo=bar</code></pre>"
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

  @to_content_data [
    %{
      input: "",
      expected: ""
    },
    %{
      input: "Pure content!",
      expected: "Pure content!"
    },
    %{
      input: "with 😀 emoji",
      expected: "with 😀 emoji"
    },
    %{
      input: "with *italic* word",
      expected: "with italic word"
    },
    %{
      input: "with **bold** word",
      expected: "with bold word"
    },
    %{
      input: "with <br /> newline",
      expected: "with \n newline"
    },
    %{
      input: "with <div>html</div>",
      expected: "with html"
    },
    %{
      input: "<div>only html</div>",
      expected: "only html"
    },
    %{
      input: "with [a link](http://www.example.com)",
      expected: "with a link"
    },
    %{
      input: "with <a href=\"http://www.example.com\">a link</a>",
      expected: "with a link"
    }
  ]

  describe "to_content/1" do
    for %{input: input, expected: expected} <- @to_content_data do
      @input input
      @expected expected

      test "converts markdown '#{inspect(@input)}' into html" do
        assert Markdown.to_content(@input) == @expected
      end
    end
  end
end
