defmodule Lib.Tilex.MarkdownTest do
  use ExUnit.Case, async: true

  describe "to_html/1" do
    test "removes script tags" do
      html =
        """
        <script>alert('A great grasshopper!')</script>
        """
        |> Tilex.Markdown.to_html()

      assert html == "<p>alert(‘A great grasshopper!’)</p>"
    end
  end

  describe "expand_relative_links/2" do
    test "works" do
      html =
        """
          <a href='/relative' id='1'>my relatives</a>
        """
        |> Tilex.Markdown.expand_relative_links("https://til.hashrocket.com")

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
        |> Tilex.Markdown.expand_relative_links("https://til.hashrocket.com")

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
        |> Tilex.Markdown.expand_relative_links("https://til.hashrocket.com")

      expected = """
        <a href="https://elixirdocs.org/strings" id="1">my relatives</a>
      """

      assert html == String.trim(expected)
    end
  end
end
