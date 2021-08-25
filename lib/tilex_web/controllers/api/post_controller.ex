defmodule TilexWeb.Api.PostController do
  @moduledoc "
  This module implements a public API for querying the Tilex feed
  "

  use TilexWeb, :controller
  alias Tilex.{Posts}

  @doc """
  This functions allows external requesters to retrieve the feed of til in json format
  """
  def index(conn, params) do
    posts = Posts.by_count(limit: params["limit"] || 10)

    render(conn, "index.json", posts: posts)
  end
end
