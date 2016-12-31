defmodule Lib.Tilex.MarkdownTest do
  use ExUnit.Case, async: true

  describe "to_html/1" do
    test "removes script tags" do
      html = """
      <script>alert('A great grasshopper!')</script>
      """
      |> Tilex.Markdown.to_html

      assert html == "<p>alert(‘A great grasshopper!’)</p>"
    end
  end
end
