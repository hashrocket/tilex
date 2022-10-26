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
      input: "Some\ntext",
      expected: "<p>Some\ntext</p>"
    },
    %{
      input: "Some<br />text",
      expected: "<p>Some<br/>text</p>"
    },
    %{
      input: "Some\n\ntext",
      expected: "<p>Some</p><p>text</p>"
    },
    %{
      input: "```\ncode block\n```",
      expected: "<pre><code class=\" language-\">code block</code></pre>"
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
      expected: "<p>alert(‘some attack’)</p>"
    },
    %{
      input: "Some http://link.com?foo=bar",
      expected: "<p>Some <a href=\"http://link.com?foo=bar\">http://link.com?foo=bar</a></p>"
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
      input: "Here's [my-link]\n\n[my-link]: http://foo/bar",
      expected: "<p>Here’s <a href=\"http://foo/bar\" title=\"\">my-link</a></p>"
    },
    %{
      input: "Here's [my-link]\n\n[my-link]: http://foo/bar \"With Title\"",
      expected: "<p>Here’s <a href=\"http://foo/bar\" title=\"With Title\">my-link</a></p>"
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
      input: "with <br /> newline",
      expected: "with \n newline"
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
      input: "with <div>html</div>",
      expected: "with html"
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
