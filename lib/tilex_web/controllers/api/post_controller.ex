defmodule TilexWeb.Api.PostController do
  @moduledoc "
  This module implements a public API for querying the Tilex feed
  "

  use TilexWeb, :controller
  import Tilex.Pageable
  alias Tilex.Posts

  @doc """
  This functions allows external requesters to retrieve the feed of til in json format
  """
  def index(conn, params) do
    page = robust_page(params)
    posts = Posts.all(page)

    render(conn, "index.json", posts: posts)
  end
end
