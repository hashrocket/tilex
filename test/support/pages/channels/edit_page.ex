defmodule Tilex.Integration.Pages.Channel.EditPage do
  use Wallaby.DSL

  alias Wallaby.Query

  @spec title_query() :: Query.t()
  def title_query(), do: Query.css("#channel_edit h1")

  @spec form_query() :: Query.t()
  def form_query(), do: Query.css("#channel_edit form")
end
