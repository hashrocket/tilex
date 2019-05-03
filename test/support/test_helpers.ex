defmodule Tilex.TestHelpers do
  use Wallaby.DSL

  def get_text(session, selector) do
    session |> find(Query.css(selector)) |> Element.text()
  end

  def text_without_newlines(element) do
    String.replace(Wallaby.Element.text(element), "\n", " ")
  end
end
