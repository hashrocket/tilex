defmodule Tilex.WallabyTestHelpers do
  use Wallaby.DSL

  alias Wallaby.Query
  alias Wallaby.Element
  alias Wallaby.Session

  @spec get_text(Session.t(), String.t() | Query.t()) :: String.t()
  def get_text(session, selector) when is_binary(selector) do
    get_text(session, Query.css(selector))
  end

  def get_text(session, query) do
    session
    |> find(query)
    |> Element.text()
  end

  @spec get_texts(Session.t(), Query.t()) :: [String.t()]
  def get_texts(session, query) do
    session
    |> all(query)
    |> Enum.map(&Element.text/1)
  end

  @spec get_table_texts(Session.t(), Query.t()) :: [[String.t()]]
  def get_table_texts(session, query) do
    table = find(session, query)

    headers = get_texts(table, Query.css("th"))

    rows =
      table
      |> all(Query.css("tbody tr"))
      |> Enum.map(&get_texts(&1, Query.css("td")))

    [headers | rows]
  end

  @spec get_form_errors(Session.t(), Query.t()) :: [{String.t(), String.t()}]
  def get_form_errors(session, query) do
    session
    |> find(query)
    |> all(Query.css(".help-block"))
    |> Enum.map(fn error ->
      {Element.attr(error, "data-field"), Element.text(error)}
    end)
  end

  @spec click_and_accept(Session.t(), Query.t()) :: [{String.t(), String.t()}]
  def click_and_accept(session, query) do
    accept_alert(session, &click(&1, query))
    session
  end

  def text_without_newlines(element) do
    String.replace(Element.text(element), "\n", " ")
  end
end
