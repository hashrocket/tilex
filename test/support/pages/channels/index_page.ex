defmodule Tilex.Integration.Pages.Channel.IndexPage do
  use Wallaby.DSL

  alias Wallaby.Query

  @spec url() :: String.t()
  def url(), do: "/channels"

  @spec title_query() :: Query.t()
  def title_query(), do: Query.css("#channel_index h1")

  @spec table_query() :: Query.t()
  def table_query(), do: Query.css("#channel_index table")
end
