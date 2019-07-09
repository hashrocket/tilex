defmodule Tilex.Integration.Pages.Channel.NewPage do
  use Wallaby.DSL

  alias Wallaby.Query

  @spec title_query() :: Query.t()
  def title_query(), do: Query.css("#channel_new h1")

  @spec form_query() :: Query.t()
  def form_query(), do: Query.css("#channel_new form")
end
