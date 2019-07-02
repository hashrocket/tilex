defmodule Lib.Tilex.MarkdownTest do
  use ExUnit.Case, async: true

  alias Tilex.Markdown

  @to_html_data [
    {"", ""},
    {"Some text", "<p>Some text</p>"},
    {"```\nsome code block\n```", "<pre><code class=\" language-\">some code block</code></pre>"},
    {"```elixir\ndefmodule Foo do\nend\n```", "<pre><code class=\"elixir language-elixir\">defmodule Foo do\nend</code></pre>"},
    {"<script>alert('A great grasshopper!')</script>", "<p>alert(‘A great grasshopper!’)</p>"},
    {"Some http://link.com?foo=bar", "<p>Some http://link.com?foo=bar</p>"},
    {"some [Link](http://link.com?foo=bar)", "<p>some <a href=\"http://link.com?foo=bar\">Link</a></p>"},
    {"some [Relative Link](/link.com?foo=bar)", "<p>some <a href=\"/link.com?foo=bar\">Relative Link</a></p>"},
    {"```\n# some http://link.com?foo=bar\n```", "<pre><code class=\" language-\"># some http://link.com?foo=bar</code></pre>"},
  ]

  describe "to_html_live/1" do
    for {value, expected} <- @to_html_data do
      @value value
      @expected expected

      test "converts markdown '#{inspect(@value)}' into html" do
        assert Markdown.to_html_live(@value) == @expected
      end
    end
  end

  describe "to_html/1" do
    for {value, expected} <- @to_html_data do
      @value value
      @expected expected

      test "converts markdown '#{inspect(@value)}' into html" do
        assert Markdown.to_html(@value) == @expected
      end
    end

    test "removes script tags" do
      html = Markdown.to_html("<script>alert('A great grasshopper!')</script>")

      assert html == "<p>alert(‘A great grasshopper!’)</p>"
    end
  end

  describe "expand_relative_links/2" do
    test "works" do
      html =
        """
          <a href='/relative' id='1'>my relatives</a>
        """
        |> Markdown.expand_relative_links("https://til.hashrocket.com")

      expected = """
        <a href="https://til.hashrocket.com/relative" id="1">my relatives</a>
      """

      assert html == String.trim(expected)
    end

    test "already expanded http" do
      html =
        """
          <a href='http://elixirdocs.org/strings' id='1'>my relatives</a>
        """
        |> Markdown.expand_relative_links("https://til.hashrocket.com")

      expected = """
        <a href="http://elixirdocs.org/strings" id="1">my relatives</a>
      """

      assert html == String.trim(expected)
    end

    test "already expanded https" do
      html =
        """
          <a href='https://elixirdocs.org/strings' id='1'>my relatives</a>
        """
        |> Markdown.expand_relative_links("https://til.hashrocket.com")

      expected = """
        <a href="https://elixirdocs.org/strings" id="1">my relatives</a>
      """

      assert html == String.trim(expected)
    end
  end
end
