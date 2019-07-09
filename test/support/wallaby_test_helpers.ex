defmodule Tilex.WallabyTestHelpers do
  use Wallaby.DSL

  alias Wallaby.Query
  alias Wallaby.Element
  alias Wallaby.Session

  def get_text(session, selector) do
    session |> find(Query.css(selector)) |> Element.text()
  end

  @spec get_texts(Session.t(), Query.t()) :: [String.t()]
  def get_texts(session, query) do
    session
    |> all(query)
    |> Enum.map(&Element.text/1)
  end

  def text_without_newlines(element) do
    String.replace(Element.text(element), "\n", " ")
  end
end
