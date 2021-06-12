defmodule TilexWeb.Api.PostController do
  @moduledoc """
  This module implements a public API for querying Tilex data.
  """

  use TilexWeb, :controller

  alias Tilex.Posts

  @doc """
  This function allows external requesters to retrieve recent posts.
  """
  def index(conn, params) do
    posts_count = Map.get(params, "count", 10)
    posts = posts_count |> Posts.limit()

    render(conn, "index.json", posts: posts)
  end
end
